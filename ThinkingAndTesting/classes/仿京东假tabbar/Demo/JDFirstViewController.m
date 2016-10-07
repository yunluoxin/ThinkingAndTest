//
//  JDFirstViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "JDFirstViewController.h"
#import "UIButton+Block.h"
#import "LoadingViewController.h"

@interface JDFirstViewController ()

@end

@implementation JDFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    __weak typeof(self) weakSelf = self ;
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        weakSelf.view.backgroundColor = [UIColor orangeColor];
        LoadingViewController *vc = [[LoadingViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(0, 200, 200, 50);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DDLog(@"JDFirstViewController");
}

@end
