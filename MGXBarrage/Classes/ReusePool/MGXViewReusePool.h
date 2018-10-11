//
//  MGXViewReusePool.h
//  MGXBarrage
//
//  Created by Miu on 2018/9/14.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGXBarrageDisplay.h"
@interface MGXViewReusePool : NSObject

@property (nonatomic,strong) NSMutableSet<UIView<MGXBarrageDisplay> *> *unusedQueue;
@property (nonatomic,strong) NSMutableSet<UIView<MGXBarrageDisplay> *> *usingQueue;

/**
 取出重用cell, 无则创建

 */
- (UIView<MGXBarrageDisplay> * _Nullable )dequeueReusableView;

/**
 加入重用池

 */
- (void)enqueueReusableView:(UIView<MGXBarrageDisplay> * _Nonnull )cell;


/**
 注册pool中的cell类型
 只能注册其中一种类型
 */
- (void)registerNib:(nullable UINib *)nib;
- (void)registerClass:(nullable Class)cellClass;

@end
