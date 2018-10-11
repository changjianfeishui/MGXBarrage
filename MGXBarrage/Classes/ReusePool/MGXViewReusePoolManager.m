//
//  MGXViewReusePoolManager.m
//  MGXBarrage
//
//  Created by Miu on 2018/9/14.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "MGXViewReusePoolManager.h"
#import "MGXViewReusePool.h"
@interface MGXViewReusePoolManager()
@property (nonatomic,strong) NSMutableDictionary *reusePools;

@end 

@implementation MGXViewReusePoolManager
#pragma mark LifeCycle
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
#pragma mark  Public Mehtod
- (MGXViewReusePool *)reusePoolForIdentifier:(NSString *)identifier
{
    MGXViewReusePool *pool = self.reusePools[identifier];
    if (pool == nil) {
        pool = [[MGXViewReusePool alloc]init];
        self.reusePools[identifier] = pool;
    }
    return pool;
}

- (NSArray <MGXViewReusePool *> *)allPools
{
    return self.reusePools.allValues;
}

#pragma mark Accessor
- (NSMutableDictionary *)reusePools
{
    if (!_reusePools) {
        _reusePools = [[NSMutableDictionary alloc]init];
    }
    return _reusePools;
}

@end
