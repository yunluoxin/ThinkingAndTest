//
//  URWrongPage_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "URWrongPage_ViewController.h"

@interface URWrongPage_ViewController ()

@end

@implementation URWrongPage_ViewController

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
    
    self.navigationItem.title = @"URWrongPage_ViewController" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    
}




#pragma mark - actions


#pragma mark - private methods

@end
