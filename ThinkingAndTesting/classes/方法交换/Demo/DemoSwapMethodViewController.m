//
//  DemoSwapMethodViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoSwapMethodViewController.h"
#import "NSObject+Method.h"
#import "UIViewController+Swizzling.h"

#import "AMethodObject.h"
#import "BMethodObject.h"
#import "BMethodObject+Swizzling.h"

@interface DemoSwapMethodViewController ()

@end

@implementation DemoSwapMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
//    [NSObject test];
    /**
     
     2016-03-21 11:15:56.272 ThinkingAndTesting[8128:491490] dd_test
     2016-03-21 11:15:56.272 ThinkingAndTesting[8128:491490] test
     
     */
    
    BMethodObject *b = [BMethodObject new] ;
    [b abc] ;
    
    UIView *a = [UIView new] ;

    UIView *a2 = [UIView new ] ;
    
    a.tagString = @"aaaaaaaa" ;
    a2.tagString = @"bbbbbbb" ;
    NSLog(@"a--%@, a2--%@",a.tagString,a2.tagString) ;
    
}


- (void)dealloc
{
    DDLog(@"被销毁");
}
@end
