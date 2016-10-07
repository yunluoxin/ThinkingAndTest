//
//  ParamGridViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ParamGridViewController.h"
#import "ParamGridView.h"
@interface ParamGridViewController ()

@end

@implementation ParamGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ParamGridView *grid = [[ParamGridView alloc]initWithDictionary:@{
                                                                     @"姓名:":@"张小东",
                                                                     @"年龄":@"13",
                                                                     @"手机号码":@"18759598185hklhkhkhkh好困好困哈可好看好困好困哈哈",
                                                                     @"工作地址是哪里":@"都发生顺达发生的sd发fgujgkh生的"
                                                                     }];
    grid.backgroundColor = [UIColor greenColor];
    grid.center = CGPointMake(DD_SCREEN_WIDTH/2, DD_SCREEN_HEIGHT/2);
    [self.view addSubview:grid];
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
