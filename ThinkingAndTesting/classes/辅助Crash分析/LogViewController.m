//
//  LogViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/18.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tap:(id)sender {
    DDLog(@"%s", __FUNCTION__);
}

@end
