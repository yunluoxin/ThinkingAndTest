//
//  DemoXibViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoXibViewController.h"
#import "TestXibViewController.h"
#import "TestXibController.h"
@interface DemoXibViewController ()

@end

@implementation DemoXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"这是第一个主要控制器" ;
    self.view.backgroundColor = [UIColor blueColor] ;
    
    
    //设置UIBarButtonItem的外观
    UIBarButtonItem *barItem=[UIBarButtonItem appearance];
    //item上边的文字样式
    NSDictionary *fontDic=@{
                            NSForegroundColorAttributeName:[UIColor greenColor],//设置barbutton里面字体的颜色
                            NSFontAttributeName:[UIFont systemFontOfSize:15],  //粗体
                            };
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateHighlighted];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"左边" style:UIBarButtonItemStyleDone target:self action:@selector(abc)] ;
    self.navigationItem.leftBarButtonItem = item ;
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"右边" style:UIBarButtonItemStyleDone target:self action:@selector(abc)] ;
    self.navigationItem.rightBarButtonItem = item2 ;
}
- (void)abc{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[TestXibViewController new] animated:YES] ;
//        [self.navigationController pushViewController:[TestXibController new] animated:YES] ;
}

@end
