//
//  CrossThirdViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CrossThirdViewController.h"
#import "TestPopverViewController.h"
@interface CrossThirdViewController ()

@end

@implementation CrossThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第3个";
    self.view.backgroundColor = [UIColor whiteColor] ;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 3 ;
    [self.view addSubview:button];
}

- (void)adb:(UIButton *)sender
{
    TestPopverViewController * vc = [TestPopverViewController new] ;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
    vc.modalPresentationStyle = UIModalPresentationPopover ;
    vc.popoverPresentationController.delegate = vc ;
    vc.popoverPresentationController.sourceView = [self.view viewWithTag:3] ;

    [self presentViewController:vc animated:YES completion:nil] ;
    return ;
    [self.navigationController popToViewController:self.backVC animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES] ;
    if (self.whenPopVC) {
        self.whenPopVC(@"第三个的 的");
    }
    
}

@end
