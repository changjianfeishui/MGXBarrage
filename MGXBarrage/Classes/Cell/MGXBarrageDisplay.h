//
//  MGXBarrageDisplay.h
//  MGXBarrage
//
//  Created by Miu on 2018/10/10.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class MGXBarrageCellDescriptor;

@protocol MGXBarrageDisplay <NSObject>

/**
 使用者应使用此方法返回弹幕宽度
 
 */
- (CGFloat)barrageWidth;

/**
 使用者应在此方法内设置弹幕内容,并计算弹幕宽高

 */
- (void)configBarrageWithDescriptor:(MGXBarrageCellDescriptor *)descriptor;

@optional
/**
 获取config方法中的descriptor
 */
- (MGXBarrageCellDescriptor *)getDescriptor;

@end

NS_ASSUME_NONNULL_END
