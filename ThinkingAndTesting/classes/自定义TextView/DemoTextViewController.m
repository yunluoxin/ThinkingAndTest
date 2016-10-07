
//
//  DemoTextViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoTextViewController.h"
#import "DDTextView.h"

@interface DemoTextViewController ()

@end

@implementation DemoTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    
    DDTextView *textView = [[DDTextView alloc]initWithFrame:CGRectMake(100, 100, 200, 300)];
//    textView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:textView];
    textView.placeholder = @"请输入文字!!不少于800字哦，少于800字可能无法得到积分的呀！！请输入文字!!请输入文字!!请输入文字!!" ;
    textView.text = @"哈回来的啦放假了" ;
    textView.layer.borderWidth = 1 / IOS_SCALE ;
    textView.layer.borderColor = [UIColor greenColor].CGColor ;
    textView.font = [UIFont systemFontOfSize:25];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
