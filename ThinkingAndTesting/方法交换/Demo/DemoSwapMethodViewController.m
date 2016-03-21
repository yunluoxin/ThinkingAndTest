//
//  DemoSwapMethodViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSwapMethodViewController.h"
#import "NSObject+Method.h"
@interface DemoSwapMethodViewController ()

@end

@implementation DemoSwapMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSObject test];
    /**
     
     2016-03-21 11:15:56.272 ThinkingAndTesting[8128:491490] dd_test
     2016-03-21 11:15:56.272 ThinkingAndTesting[8128:491490] test
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
