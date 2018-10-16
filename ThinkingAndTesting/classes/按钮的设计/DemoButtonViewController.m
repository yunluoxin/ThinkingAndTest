//
//  DemoButtonViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoButtonViewController.h"
#import "FilterOptionButton.h"
#import "UpDownHorizontallyAlignCenterButton.h"

@interface DemoButtonViewController ()

@end

@implementation DemoButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button] ;
    button.frame = CGRectMake(100, 100, 100, 50);
    
    [button setTitle:@"我们" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
    [button setTitle:@"我们" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected] ;
    
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    FilterOptionButton *button2 = [[FilterOptionButton alloc]initWithFrame:CGRectMake(100, 200, 100, 50)];
    [button2 setTitle:@"哈哈" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    
    UpDownHorizontallyAlignCenterButton *btn = [[UpDownHorizontallyAlignCenterButton alloc]initWithFrame:CGRectMake(100, 350, 60, 100)];
    [btn setTitle:@"我是文字" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btn.imageWidth = 30.f;
//    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.imageMarginTop = 8;
    btn.imageMarginBottom = 8;
    btn.titleMarginBottom = 8;
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

/**
 *  单击事件，改变按钮的样式
 *
 */
- (void)click:(UIButton *)button
{
    button.selected =  !button.selected ;
    if (button.selected) {
        button.layer.borderWidth = 1 / IOS_SCALE ;
        button.layer.borderColor = [UIColor greenColor].CGColor;
    }else{
        button.layer.borderWidth = 0 ;
    }
}

- (void)click2:(UIButton *)button
{
    button.selected =  !button.selected ;
}
@end
