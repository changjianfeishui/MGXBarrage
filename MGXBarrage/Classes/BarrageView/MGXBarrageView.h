//
//  MGXBarrageView.h
//  MGXBarrage
//
//  Created by Miu on 2018/8/29.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGXBarrageDisplay.h"
@class MGXBarrageView,MGXBarrageCellDescriptor;

@protocol MGXBarrageViewDataSource <NSObject>
/**
 有多少条轨道
 */
- (NSInteger)numberOfTracksInBarrageView:(MGXBarrageView *)barrageView;

/**
 指定轨道高度
 @discussion 轨道宽度与其父视图MGXBarrageView一致
 */
- (CGFloat)barrageView:(MGXBarrageView *)barrageView heightForTrackAtIndex:(NSInteger)index;
@end



@protocol MGXBarrageViewDelegate <NSObject>
@optional
/**
 选中弹幕
 */
- (void)barrageView:(MGXBarrageView *)barrageView didSelectBarrageCell:(UIView<MGXBarrageDisplay> *)cell;
@end



@interface MGXBarrageView : UIView
@property (nonatomic,weak) id<MGXBarrageViewDataSource> dataSource;
@property (nonatomic,weak) id<MGXBarrageViewDelegate> delegate;
/**
 两条弹幕的最小间距, 默认10, 最大有效值为屏幕宽度
 */
@property (nonatomic,assign) CGFloat barrageMinSpace;
/**
 弹幕速度,默认为100;
 */
@property (nonatomic,assign) CGFloat speed;

/**
 注册cell
 */
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/**
 发射弹幕
 */
- (void)sendBarrage:(MGXBarrageCellDescriptor *)descriptor;
- (void)sendBarrages:(NSArray<MGXBarrageCellDescriptor *> *)descriptors;

/**
 停止弹幕
 */
- (void)stop;

@end



