//
//  NibCanAwakeViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NibCanAwakeViewController.h"
#import "NibView.h"
@interface NibCanAwakeViewController ()

@end

@implementation NibCanAwakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NibView *nib = [[NibView alloc]init];
    [self.view addSubview:nib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 结果:
    2016-01-29 08:26:05.641 ThinkingAndTesting[29223:1116893] init方法
    2016-01-29 08:26:05.657 ThinkingAndTesting[29223:1116893] awakeFromNib
*/

@end
