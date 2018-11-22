
//
//  ObserverMode_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ObserverMode_ViewController.h"
#import "DDNotificationCenter.h"

#import "TestPage2_ViewController.h"

@interface ObserverMode_ViewController () {
    id observer;
}
@end

@implementation ObserverMode_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"DDNotificationCenter Test" ;
    
    [[DDNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"test" object:nil] ;
    
    observer = [[DDNotificationCenter defaultCenter] addObserverForName:@"abc" object:self queue:nil usingBlock:^(DDNotification * _Nonnull note) {
        DDLog(@"receive notification name [abc], %@", note);
        delay_main(2, ^{
            [[DDNotificationCenter defaultCenter] removeObserver:observer];
        });
    }];
}

- (void)test:(id)obj
{
    DDLog(@"test:::::   \n%@",obj) ;
    
//    [[DDNotificationCenter defaultCenter] removeObserver:self] ;
    [[DDNotificationCenter defaultCenter] removeObserver:self] ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[DDNotificationCenter defaultCenter] postNotificationName:@"test" object:self userInfo:@{@"abc":@"dadong"}] ;
     [[DDNotificationCenter defaultCenter] postNotificationName:@"abc" object:self userInfo:@{@"abc":@"dadong"}] ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}

@end
