//
//  CTMViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CTMViewController.h"
#import "CTMView.h"

@interface CTMViewController ()

@end

@implementation CTMViewController

- (void)loadView
{
    self.view = [CTMView new] ;
    self.view.backgroundColor = [UIColor greenColor] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
