//
//  CrossFirstViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CrossFirstViewController.h"
#import "CrossSecondViewController.h"
@interface CrossFirstViewController ()
@property (nonatomic, weak)UILabel *label  ;
@end

@implementation CrossFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第一个";
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"ddd";
    _label = label ;
    label.frame = CGRectMake(100, 100, 50, 200);
    label.textColor = [UIColor orangeColor];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(100, 50, 30, 30);
    [button addTarget:self action:@selector(adb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)adb:(UIButton *)sender
{
    CrossSecondViewController *vc = [[CrossSecondViewController alloc]init];

    vc.whenPopVC = ^(NSString *name){
        self.label.text = name ;
    };
    vc.backVC = self ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
