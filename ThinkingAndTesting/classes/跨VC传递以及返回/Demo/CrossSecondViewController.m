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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)adb:(UIButton *)sender
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
