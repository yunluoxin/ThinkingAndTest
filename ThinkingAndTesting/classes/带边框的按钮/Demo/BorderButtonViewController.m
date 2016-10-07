//
//  BorderButtonViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BorderButtonViewController.h"
#import "DDBorderButton.h"
@interface BorderButtonViewController ()

@end

@implementation BorderButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"边框按钮" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 50);
    // 按钮边框宽度
    button.layer.borderWidth = 1.5;
    // 设置圆角
    button.layer.cornerRadius = 4.5;
    // 设置颜色空间为rgb，用于生成ColorRef
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    // 设置边框颜色
    button.layer.borderColor = borderColorRef;
    
    [self.view addSubview:button];
    
    
    DDBorderButton *borderButton = [[DDBorderButton alloc]initWithFrame:CGRectMake(100, 100, 150, 50)];
    [borderButton setTitle:@"第二个" forState:UIControlStateNormal];
    borderButton.borderWidth = 0 ;
    borderButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:borderButton];
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
