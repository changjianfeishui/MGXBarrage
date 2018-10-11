//
//  MGXViewController.m
//  MGXBarrage
//
//  Created by 329735967@qq.com on 10/11/2018.
//  Copyright (c) 2018 329735967@qq.com. All rights reserved.
//

#import "MGXViewController.h"
#import "MGXBarrageView.h"
#import "MGXBarrageCellDescriptor.h"

@interface MGXViewController ()<MGXBarrageViewDelegate,MGXBarrageViewDataSource>
@property (nonatomic,strong) MGXBarrageView *barrageView;

@end

@implementation MGXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.barrageView = [[MGXBarrageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.barrageView];
    
    [self.barrageView registerClass:NSClassFromString(@"MGXBarrageViewTextCell") forCellReuseIdentifier:@"MGXBarrageViewTextCell"];
    [self.barrageView registerNib:[UINib nibWithNibName:@"MGXFPSTestCell" bundle:nil] forCellReuseIdentifier:@"MGXFPSTestCell"];
    
    self.barrageView.dataSource = self;
    self.barrageView.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.barrageView stop];
}

- (IBAction)sendBarrage:(id)sender {
    NSMutableArray *textItems = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10 ; i++) {
        [textItems addObject:[self randomTextDescriptor]];
    }
    [self.barrageView sendBarrages:textItems];
    
    NSMutableArray *imageItems = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 20; i++) {
        MGXBarrageCellDescriptor *descriptor = [[MGXBarrageCellDescriptor alloc]init];
        descriptor.identifier = @"MGXFPSTestCell";
        [imageItems addObject:descriptor];
    }
    [self.barrageView sendBarrages:imageItems];
    
}

- (MGXBarrageCellDescriptor *)randomTextDescriptor
{
    static NSString *text = @"状态模式将状态封装成为独立的类, 并将动作传递给当前的状态对象. 通过这种方式允许对象在内部状态改变时同时改变其行为, 即调用相同的对象方法, 但是对象会根据内部状态不同执行不同的行为.代理模式为另一个对象提供一个替身或占位符以控制对这个对象的访问。状态模式将状态封装成为独立的类, 并将动作传递给当前的状态对象. 通过这种方式允许对象在内部状态改变时同时改变其行为, 即调用相同的对象方法, 但是对象会根据内部状态不同执行不同的行为.组合模式允许将对象组合成树形结构来表现”整体/部分”的层次结构。组合能让客户以一致的方式处理个别对象以及对象组合。";
    MGXBarrageCellDescriptor *descriptor = [[MGXBarrageCellDescriptor alloc]init];
    NSInteger len = text.length;
    NSInteger randomLocation = arc4random_uniform((uint32_t)len-11);
    NSInteger randomLen = arc4random_uniform(10)+2;
    
    NSString *randomStr = [text substringWithRange:NSMakeRange(randomLocation, randomLen)];
    descriptor.userInfo = [[NSAttributedString alloc]initWithString:randomStr];
    descriptor.identifier = @"MGXBarrageViewTextCell";
    return descriptor;
}

#pragma mark MGXBarrageViewDataSource
- (NSInteger)numberOfTracksInBarrageView:(MGXBarrageView *)barrageView
{
    return self.barrageView.bounds.size.height/40;
}

- (CGFloat)barrageView:(MGXBarrageView *)barrageView heightForTrackAtIndex:(NSInteger)index
{
    return 40;
}


#pragma mark MGXBarrageViewDelegate
- (void)barrageView:(MGXBarrageView *)barrageView didSelectBarrageCell:(UIView<MGXBarrageDisplay> *)cell
{
    if ([cell isKindOfClass:NSClassFromString(@"MGXBarrageViewTextCell")]) {
        MGXBarrageCellDescriptor *descriptor = [cell getDescriptor] ;
        NSLog(@"点击文本=====%@",descriptor.userInfo);
    }else if ([cell isKindOfClass:NSClassFromString(@"MGXFPSTestCell")]){
        NSLog(@"点击其他===%@",[cell class]);
    }
    

}
@end
