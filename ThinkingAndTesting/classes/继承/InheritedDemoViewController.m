//
//  InheritedDemoViewController.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/29.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "InheritedDemoViewController.h"
#import "ParentClassA.h"
#import "SubClassB.h"

@interface InheritedDemoViewController ()

@end

@implementation InheritedDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Inherited Demo" ;
    
    self.view.backgroundColor = RandomColor ;
    
    SubClassB * b = [SubClassB new] ;
    
    [b parentMethodA] ;
    
    /*
     
     2018-09-26 11:09:52: ParentClassA.m 第15行: 这是父类方法A
     
     2018-09-26 11:09:57: SubClassB.m 第25行: 子类方法B
     
     2018-09-26 11:09:57: SubClassB.m 第17行: 子类方法A
     
     2018-09-26 11:09:57: SubClassB.m 第25行: 子类方法B
     
     */
    ///
    /// @conclusion super只是一个编译器指示符！！！哪怕从子类中调用了super到父类里，当前的self还是子类对象！调用的
    ///             parentMethodB方法还是属于子类的！
    ///
    ///
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController.view printSubviewsRecursively] ;
}

@end
