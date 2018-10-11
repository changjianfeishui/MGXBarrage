//
//  MGXBarrageCellDescriptor.h
//  MGXBarrage
//
//  Created by Miu on 2018/9/21.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGXBarrageCellDescriptor : NSObject

/**
 重用标识符
 @discussion 使用前需进行注册
 */
@property (nonatomic,strong) NSString *identifier;

/**
 自定义数据
 */
@property (nonatomic,strong) id userInfo;

@end

NS_ASSUME_NONNULL_END
