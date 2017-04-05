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
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    [DDUtils bundleIDsOfAllInstalledApps] ;
}




#pragma mark - actions


#pragma mark - private methods

@end
