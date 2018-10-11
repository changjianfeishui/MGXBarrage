//
//  MGXTextBarrageCell.m
//  MGXBarrage
//
//  Created by Miu on 2018/9/26.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "MGXBarrageViewTextCell.h"
#import "MGXBarrageCellDescriptor.h"
@interface MGXBarrageViewTextCell()
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) MGXBarrageCellDescriptor *descriptor;

@end

@implementation MGXBarrageViewTextCell
#pragma mark LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark SetupUI
- (void)setupUI
{
    self.contentLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.contentLabel.numberOfLines = 1;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:17];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.contentLabel];
}

#pragma mark MGXBarrageDisplay
- (CGFloat)barrageWidth
{
    return self.frame.size.width;
}

- (void)configBarrageWithDescriptor:(MGXBarrageCellDescriptor *)descriptor
{
    self.descriptor = descriptor;
    self.contentLabel.attributedText = descriptor.userInfo;
    [self.contentLabel sizeToFit];
    CGRect contentBounds = self.contentLabel.bounds;

    self.frame = CGRectMake(0, 0, contentBounds.size.width + 20, contentBounds.size.height + 10);
    self.contentLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    self.layer.cornerRadius = self.bounds.size.height * 0.5;
}

- (MGXBarrageCellDescriptor *)getDescriptor
{
    return self.descriptor;
}

@end

