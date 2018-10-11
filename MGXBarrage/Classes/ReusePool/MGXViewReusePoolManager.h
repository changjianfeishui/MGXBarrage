//
//  MGXViewReusePoolManager.h
//  MGXBarrage
//
//  Created by Miu on 2018/9/14.
//  Copyright © 2018年 MGX. All rights reserved.
//  管理多个重用池

#import <Foundation/Foundation.h>
@class MGXViewReusePool;
@interface MGXViewReusePoolManager : NSObject

/**
 获取重用池

 @param identifier 唯一标识
 */
- (MGXViewReusePool *)reusePoolForIdentifier:(NSString *)identifier;



/**
 获取所有重用池

 @return all reuse pools
 */
- (NSArray <MGXViewReusePool *> *)allPools;

@end
