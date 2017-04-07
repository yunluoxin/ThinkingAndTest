//
//  PrivateAPIDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/31.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "PrivateAPIDemoViewController.h"

#import "DDUtils+PrivateAPI.h"

@interface PrivateAPIDemoViewController ()

@end

@implementation PrivateAPIDemoViewController

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
    
    self.navigationItem.title = @"PrivateAPIDemoViewController" ;
    
    self.view.backgroundColor = [UIColor redColor] ;
    
    [DDUtils bundleIDsOfAllInstalledApps] ;
    
    [self showNavigationBarBottomLine] ;
    
    self.handleKeyboardEvent = YES ;
}


- (void)viewDidAppear:(BOOL)animated
{
    [self showText:@"Hello World!!!"] ;
}

#pragma mark - actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    if (self.isStatusBarVisible) {
//        [self hideStatusBarAnimated:YES] ;
//    }else{
//        [self showStatusBarAnimated:YES] ;
//    }
    
    if (self.isNavigationBarVisible) {
        [self hideNavigationBarAnimated:YES] ;
    }else{
        [self showNavigationBarAnimated:YES] ;
    }

    [self dismissAllHudsAfter:2] ;
}
#pragma mark - private methods

@end
