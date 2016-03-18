//
//  LoadingViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LoadingViewController.h"
#import "DDProgressHUD.h"
#import "UIButton+Block.h"


@interface LoadingViewController ()<UITextFieldDelegate>
@property (nonatomic, weak)UIView *rV ;
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    DDProgressHUD *hud = [DDProgressHUD sharedInstance];
    UIView *rV = [UIButton buttonWithType:UIButtonTypeContactAdd];
    rV.frame = CGRectMake(0, 70, 10, 10);
    _rV = rV ;
    [self.view addSubview:rV];
    
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
//        [hud beginAnimatation];
        [[DDProgressHUD sharedInstance] showStatus:@"d" onlyInView:self.rV];
    }];
    [button setTitle:@"start" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(0, 100, 100, 50);
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithBlock:^(UIButton *button) {
//        [hud stopAnimatation];
        [self.rV removeFromSuperview];
    }];
    [button2 setTitle:@"stop" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor greenColor];
    button2.frame = CGRectMake(0, 200, 100, 50);
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithBlock:^(UIButton *button) {
                [hud beginAnimatation];
    }];
    [button3 setTitle:@"reStart" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor greenColor];
    button3.frame = CGRectMake(108, 100, 100, 50);
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithBlock:^(UIButton *button) {
                [hud stopAnimatation];
    }];
    [button4 setTitle:@"reStop" forState:UIControlStateNormal];
    button4.backgroundColor = [UIColor greenColor];
    button4.frame = CGRectMake(108, 200, 100, 50);
    [self.view addSubview:button4];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self ;
    [self.view addSubview:textField];
    textField.frame = CGRectMake(0, 80, 100, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UIButton *)sender
{
    [[DDProgressHUD sharedInstance] showStatus:@"d" onlyInView:self.rV];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
@end
