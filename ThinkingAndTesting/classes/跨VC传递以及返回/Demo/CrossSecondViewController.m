//
//  CrossSecondViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CrossSecondViewController.h"
#import "CrossThirdViewController.h"
@interface CrossSecondViewController ()

@end

@implementation CrossSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第2个";
        self.view.backgroundColor = [UIColor whiteColor] ;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0,200, self.view.dd_width, 50)] ;
    [self.view addSubview:textField] ;
    textField.backgroundColor = [UIColor yellowColor] ;
}

- (void)adb:(UIButton *)sender
{
    [self dd_redirectTo:[CrossSecondViewController new]] ;
    return ;
    __weak typeof(self) weakSelf = self ;
    CrossThirdViewController *vc = [[CrossThirdViewController alloc]init];
    vc.whenPopVC = ^(NSString *name){
        if (weakSelf.whenPopVC) {
            weakSelf.whenPopVC(name);
        }
    };
    vc.backVC = self.backVC ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES] ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}
@end
