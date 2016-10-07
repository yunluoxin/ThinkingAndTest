//
//  A_ViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/9/1.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "A_ViewController.h"
#import "B_ViewController.h"

@interface A_ViewController ()

@end

@implementation A_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"弹出" style:UIBarButtonItemStyleDone target:self action:@selector(present)] ;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"推到下一个" style:UIBarButtonItemStyleDone target:self action:@selector(push)] ;
}

- (void)present
{
    B_ViewController *vc = [B_ViewController new] ;
    [self presentViewController:vc animated:YES completion:^{

    }];
}
- (void)push
{
    B_ViewController *vc = [B_ViewController new] ;
    [self.navigationController pushViewController:vc animated:YES] ;
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
