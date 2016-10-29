//
//  DemoCyclePlayViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoCyclePlayViewController.h"
#import "CyclePlayView.h"

@interface DemoCyclePlayViewController ()<CyclePlayViewDelegate>

@property (nonatomic, strong) NSArray<CycleEntity *>  * arrayList ;
@end

@implementation DemoCyclePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CyclePlayView *playView = [[CyclePlayView alloc]initWithFrame:CGRectMake(0, 64, self.view.dd_width, 150)];
    [self.view addSubview:playView] ;
    playView.delegate = self ;
    playView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        playView.arrayList = self.arrayList ;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<CycleEntity *> *)arrayList
{
    if (!_arrayList) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0 ; i < 5; i ++) {
            CycleEntity *entity = [CycleEntity new];
            entity.id = [NSString stringWithFormat:@"%d",i];
            entity.imageUrl = entity.id ;
            [arrayM addObject:entity];
        }
        _arrayList = [arrayM copy];
    }
    return _arrayList ;
}

- (void)cyclePlayView:(CyclePlayView *)cyclePlayView didSelectedItemAtIndex:(NSInteger)index
{
    DDLog(@"didSelectedItemAtIndex--%ld",index);
}
@end
