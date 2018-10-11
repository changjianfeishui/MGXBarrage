//
//  UIImage+MGXCircleImage.m
//  MGXBarrage
//
//  Created by Miu on 2018/10/10.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "UIImage+MGXCircleImage.h"

@implementation UIImage (MGXCircleImage)
- (UIImage *)mgx_circleImage
{
    CGFloat radius = MIN(self.size.height, self.size.width);
    UIGraphicsBeginImageContext(CGSizeMake(radius, radius));
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)];
    [path addClip];
    [self drawAtPoint:CGPointMake(0, 0)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}
@end
