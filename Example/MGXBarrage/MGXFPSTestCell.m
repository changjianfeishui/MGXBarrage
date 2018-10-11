//
//  MGXImageRadiusCell.m
//  MGXBarrage
//
//  Created by Miu on 2018/10/10.
//  Copyright © 2018年 MGX. All rights reserved.
//

#import "MGXFPSTestCell.h"
#import "UIImage+MGXCircleImage.h"
@interface MGXFPSTestCell()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgvs;


@end

@implementation MGXFPSTestCell
#pragma mark MGXBarrageDisplay
- (CGFloat)barrageWidth
{
    return 355;
}

/**
 使用者应在此方法内设置弹幕内容,并计算弹幕宽度
 
 */
- (void)configBarrageWithDescriptor:(MGXBarrageCellDescriptor *)descriptor
{
    UIImage *origin = [UIImage imageNamed:@"111"];
    UIImage *circle = origin.mgx_circleImage;
        for (UIImageView *imgv in self.imgvs) {
            imgv.image = circle;
        }
}

@end
