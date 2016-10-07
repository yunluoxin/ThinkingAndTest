//
//  TouchDemoViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TouchDemoViewController.h"
#import "TouchAView.h"
#import "TouchBView.h"

@interface TouchDemoViewController ()

@end

@implementation TouchDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TouchAView *a = [[TouchAView alloc]initWithFrame:self.view.bounds] ;
    [self.view addSubview:a] ;
    a.userInteractionEnabled = NO ;
    TouchBView *b = [[TouchBView alloc]initWithFrame:self.view.bounds] ;
    [a addSubview:b] ;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)] ;
    [a addGestureRecognizer:tap ] ;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__) ;
    [super touchesBegan:touches withEvent:event] ;
}


- (void)tap{
    DDLog(@"tapl......l") ;
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
