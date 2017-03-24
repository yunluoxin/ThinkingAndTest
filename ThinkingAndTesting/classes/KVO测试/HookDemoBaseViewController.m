//
//  HookDemoBaseViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/24.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "HookDemoBaseViewController.h"

@interface HookDemoBaseViewController ()

@end

@implementation HookDemoBaseViewController

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self ;
}

- (void)dealloc
{
    NSLog(@"%s",__func__) ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"HookDemoBaseViewController" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    DDLog(@"\n\n\n\n\n\nnn\n\n\n HookDemoBaseViewController \n\nn\n\n\n") ;
}


#pragma mark - actions


#pragma mark - private methods

@end
