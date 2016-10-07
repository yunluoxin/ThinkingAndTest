//
//  GoodsSyleViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "GoodsSyleViewController.h"
#import "GoodsSytleButton.h"

#import "GoodsStyleView.h"
@interface GoodsSyleViewController ()

@end

@implementation GoodsSyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GoodsSytleButton *btn = [[GoodsSytleButton alloc]init];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"哈哈" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    btn.center = CGPointMake(100, 50);
    [self.view addSubview:btn];
    
    NSDictionary *dic = @{
                                     @"1": @"内增高",
                                     @"2": @"普通",
                                     @"3": @"普通普内增高内增通普通",
                                     @"4": @"普通普通",
                                     @"5": @"内增高",
                                     @"6": @"普通",
                                     @"7": @"普通内增高普通",
                                     @"8": @"普内增高通内增高普通",
                                     @"keys": @"1,2,3,4,5,8,6,7"
                                     };
    CGFloat height = [GoodsStyleView calcuateHeight:dic];
    GoodsStyleView *sV = [[GoodsStyleView alloc]initWithTitle:@"款式:" andDictionary:dic andSeletedCode:@"8" ];
    sV.frame = CGRectMake(0, 100, DD_SCREEN_WIDTH, height);
//    sV.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:sV];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(UIButton *)button
{
    button.selected = !button.selected ;
}

@end
