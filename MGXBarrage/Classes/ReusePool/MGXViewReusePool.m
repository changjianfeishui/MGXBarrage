//
//  MGXViewReusePool.m
//  MGXBarrage
//
//  Created by Miu on 2018/9/14.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "MGXViewReusePool.h"
@interface MGXViewReusePool()


@property (nonatomic,assign) Class cellClass;

@property (nonatomic,strong) UINib *nib;

@end
@implementation MGXViewReusePool
#pragma mark LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
#pragma mak Public Method
- (UIView<MGXBarrageDisplay> *)dequeueReusableView;
{    
    UIView<MGXBarrageDisplay> *cell = [self.unusedQueue anyObject];
    if (cell == nil) {
        if (self.nib != nil) {
            cell = [[self.nib instantiateWithOwner:nil options:nil] firstObject];
        }else if(self.cellClass != Nil){
            cell = [[self.cellClass alloc]init];
        }else{
            NSException *exception = [NSException exceptionWithName:@"Cell Unregister" reason:@"使用前必须先注册cell" userInfo:nil];
            [exception raise];
        }
        [self.usingQueue addObject:cell];
        return cell;
    }else{
        [self.unusedQueue removeObject:cell];
        [self.usingQueue addObject:cell];
        return cell;
    }
}


- (void)enqueueReusableView:(UIView<MGXBarrageDisplay> *)cell
{
    if (cell == nil) {
        return;
    }
    [self.usingQueue removeObject:cell];
    [self.unusedQueue addObject:cell];
}


- (void)registerNib:(nullable UINib *)nib
{
    NSAssert(self.cellClass == Nil, @"不能重复注册");
    self.nib = nib;    
}
- (void)registerClass:(nullable Class)cellClass
{
    NSAssert(self.nib == nil, @"不能重复注册");
    self.cellClass = cellClass;
}

#pragma mark Accessor
- (NSMutableSet<UIView<MGXBarrageDisplay> *> *)usingQueue
{
    if (!_usingQueue) {
        _usingQueue = [NSMutableSet set];
    }
    return _usingQueue;
}

- (NSMutableSet<UIView<MGXBarrageDisplay> *> *)unusedQueue
{
    if (!_unusedQueue) {
        _unusedQueue = [NSMutableSet set];
    }
    return _unusedQueue;
}


@end
