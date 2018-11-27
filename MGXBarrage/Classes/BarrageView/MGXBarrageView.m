//
//  MGXBarrageView.m
//  MGXBarrage
//
//  Created by Miu on 2018/8/29.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "MGXBarrageView.h"
#import "MGXBarrageTrackView.h"
#import "MGXViewReusePool.h"
#import "MGXViewReusePoolManager.h"
#import "MGXBarrageCellDescriptor.h"

#define XBRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

#define MGXBarrageDefaultSpeed 100;

@interface MGXBarrageView()<CAAnimationDelegate>
@property (nonatomic,strong) MGXViewReusePoolManager *poolMgr;
@property (nonatomic,strong) NSMutableArray<MGXBarrageTrackView *> *tracks;
@property (nonatomic,strong) NSMutableArray<MGXBarrageCellDescriptor *> *descriptorItems;

@property (nonatomic,strong) dispatch_semaphore_t dataSourceLock;
@property (nonatomic,strong) dispatch_semaphore_t readLock;

@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,assign) NSInteger idleCount;

@end

@implementation MGXBarrageView
#pragma mark LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupVars];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupVars];
    }
    return self;
}

- (void)setupVars
{
    _dataSourceLock = dispatch_semaphore_create(1);
    _readLock = dispatch_semaphore_create(1);
    _barrageMinSpace = 10;
    _speed = MGXBarrageDefaultSpeed;
    _idleCount = 0;
}

#pragma mark SetupTrack
- (void)prepareTrack
{
    if (!self.dataSource) {
        NSAssert(self.dataSource != nil, @"必须实现MGXBarrageViewDataSource协议");
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfTracksInBarrageView:)]) {
        NSInteger numberOfTracks = [self.dataSource numberOfTracksInBarrageView:self];
        CGFloat preTrackHeight = 0;
        for (int i = 0; i < numberOfTracks; i++) {
            MGXBarrageTrackView *track = [[MGXBarrageTrackView alloc]init];
            CGFloat height = 0;
            if ([self.dataSource respondsToSelector:@selector(barrageView:heightForTrackAtIndex:)]) {
                height = [self.dataSource barrageView:self heightForTrackAtIndex:i];
            }
            track.frame = CGRectMake(0, preTrackHeight, self.bounds.size.width, height);
            preTrackHeight += height;
            [self addSubview:track];
            [self.tracks addObject:track];
        }
    }
}

#pragma mark Reuse Pool
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    MGXViewReusePool *pool = [self.poolMgr reusePoolForIdentifier:identifier];
    [pool registerNib:nib];
}
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    MGXViewReusePool *pool = [self.poolMgr reusePoolForIdentifier:identifier];
    [pool registerClass:cellClass];
}
- (UIView<MGXBarrageDisplay> *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    MGXViewReusePool *pool = [self.poolMgr reusePoolForIdentifier:identifier];
    UIView<MGXBarrageDisplay> *cell = [pool dequeueReusableView];
    return cell;
}
#pragma mark Send Barrage
- (void)sendBarrage:(MGXBarrageCellDescriptor *)descriptor
{
    [self sendBarrages:@[descriptor]];
}

- (void)sendBarrages:(NSArray<MGXBarrageCellDescriptor *> *)descriptors
{

    if (self.tracks.count == 0) {
        [self prepareTrack];
    }
    
    dispatch_semaphore_wait(_dataSourceLock, DISPATCH_TIME_FOREVER);
    [self.descriptorItems addObjectsFromArray:descriptors];
    dispatch_semaphore_signal(_dataSourceLock);
    if (!_displayLink) {
        [self setupTimer];
    }
}

- (void)stop
{
    [self releaseTimer];
    for (int i = 0; i < self.poolMgr.allPools.count; i++) {
        MGXViewReusePool *pool = self.poolMgr.allPools[i];
        for (UIView *cell in pool.usingQueue) {
            [cell.layer removeAllAnimations];
        }
    }
}


#pragma mark Timer
- (void)setupTimer
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(prepareAnimation)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)releaseTimer
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    _idleCount = 0;
}

#pragma mark Barrage Animation
- (void)prepareAnimation
{
    if (self.descriptorItems.count == 0) {
        //10s连续轮空
        if (_idleCount++ >= 60 * 10) {
            [self releaseTimer];
        }
        return;
    }
    dispatch_semaphore_wait(_readLock, DISPATCH_TIME_FOREVER);
    MGXBarrageTrackView *idleTrack = nil;
    for (MGXBarrageTrackView *track in self.tracks) {
        if ([track isAvailableForTailSpace:self.barrageMinSpace]) {
            idleTrack = track;
            break;
        }
    }
    if (idleTrack == nil) {
        dispatch_semaphore_signal(_readLock);
        return;
    }
    
    MGXBarrageCellDescriptor *descriptor = [self.descriptorItems firstObject];
    [self.descriptorItems removeObjectAtIndex:0];
    
    UIView<MGXBarrageDisplay> *cell = [self dequeueReusableCellWithIdentifier:descriptor.identifier];
    [idleTrack addSubview:cell];
    [cell configBarrageWithDescriptor:descriptor];
    CGFloat cellWidth = [cell barrageWidth];
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    cell.center = CGPointMake(screenWith + 0.5 * cellWidth, idleTrack.bounds.size.height * 0.5);
    NSTimeInterval duration = (cellWidth + screenWith)/self.speed;
    
    CABasicAnimation *animation = [[CABasicAnimation alloc]init];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(screenWith + 0.5 * cellWidth, idleTrack.bounds.size.height * 0.5)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-0.5 * cellWidth, idleTrack.bounds.size.height * 0.5)];
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [cell.layer addAnimation:animation forKey:@"MGXBarrageView"];
    dispatch_semaphore_signal(_readLock);
}


#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    for (int i = 0; i < self.poolMgr.allPools.count; i++) {
        MGXViewReusePool *pool = self.poolMgr.allPools[i];
        for (UIView<MGXBarrageDisplay> *cell in pool.usingQueue) {
            CAAnimation *ani = [cell.layer animationForKey:@"MGXBarrageView"];
            if (ani == anim) {
                [cell.layer removeAnimationForKey:@"MGXBarrageView"];
                [cell removeFromSuperview];
                [pool enqueueReusableView:cell];
                break;
            }
        }
    }
}

#pragma mark ResponseChain
- (BOOL)touchesCheck:(CGPoint)point
{
    for (int i = 0; i < self.poolMgr.allPools.count; i++) {
        MGXViewReusePool *pool = self.poolMgr.allPools[i];
        for (UIView<MGXBarrageDisplay> *cell in pool.usingQueue) {
            CGRect frame = cell.layer.presentationLayer.frame;
            frame = [cell.superview convertRect:frame toView:self];
            if (CGRectContainsPoint(frame, point)) {
                if ([self.delegate respondsToSelector:@selector(barrageView:didSelectBarrageCell:)]) {
                    [self.delegate barrageView:self didSelectBarrageCell:cell];
                }
                return YES;
            }
        }
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(barrageView:didSelectBarrageCell:)]) {
        return nil;
    }
    
    if ([self touchesCheck:point]) {
        return self;
    }
    return nil;
}


#pragma mark Accessor
- (NSMutableArray *)tracks
{
    if (!_tracks) {
        _tracks = [NSMutableArray array];
    }
    return _tracks;
}

- (MGXViewReusePoolManager *)poolMgr
{
    if (!_poolMgr) {
        _poolMgr = [[MGXViewReusePoolManager alloc]init];
    }
    return _poolMgr;
}

- (NSMutableArray *)descriptorItems
{
    if (!_descriptorItems) {
        _descriptorItems = [NSMutableArray array];
    }
    return _descriptorItems;
}

- (void)setBarrageMinSpace:(CGFloat)barrageMinSpace
{
    if (barrageMinSpace > [UIScreen mainScreen].bounds.size.width) {
        barrageMinSpace = [UIScreen mainScreen].bounds.size.width;
    }
    _barrageMinSpace = barrageMinSpace;
}


- (void)setSpeed:(CGFloat)speed
{
    if (speed <= 0) {
        speed = MGXBarrageDefaultSpeed;
    }
    _speed = speed;
}

@end
