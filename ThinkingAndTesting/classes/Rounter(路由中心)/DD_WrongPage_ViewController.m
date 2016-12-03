//
//  DD_WrongPage_ViewController.m
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DD_WrongPage_ViewController.h"

@interface DD_WrongPage_ViewController ()

@end

@implementation DD_WrongPage_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"页面找不到啦" ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    UILabel * label = [[UILabel alloc]initWithFrame:self.view.bounds] ;
    label.numberOfLines = 0 ;
    label.textColor = [UIColor blackColor] ;
    label.font = [UIFont systemFontOfSize:18] ;
    label.text = @"亲，实在抱歉T_T,页面找不到了呀\n去其他页面看看吧！";
    [self.view addSubview:label] ;
}

@end
