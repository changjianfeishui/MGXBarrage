//
//  MGXBarrageTrackView.m
//  MGXBarrage
//
//  Created by Miu on 2018/9/12.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "MGXBarrageTrackView.h"
@implementation MGXBarrageTrackView

- (BOOL)isAvailableForTailSpace:(CGFloat)space
{
    if (self.layer.sublayers.count == 0) {
        return YES;
    }
    CALayer *cellLayer = [self.layer.sublayers lastObject];
    CGRect rect = cellLayer.presentationLayer.frame;
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat currentSpace = self.bounds.size.width - maxX;

    if (currentSpace > space) {
        return YES;
    }
    return NO;
}


@end
