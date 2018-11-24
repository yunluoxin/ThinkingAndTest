
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
    
    @synchronized (self) {
        DDLog(@"1%s", __func__);
        @synchronized (self) {
            DDLog(@"2%s", __func__);
        }
    }
    
    self.navigationItem.title = @"DDNotificationCenter Test" ;
    
    
    
    [[DDNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"test" object:nil] ;
    
    
    
    observer = [[DDNotificationCenter defaultCenter] addObserverForName:@"abc" object:self queue:nil usingBlock:^(DDNotification * _Nonnull note) {
        DDLog(@"receive notification name [abc], %@", note);
        
        delay_main(2, ^{
            [[DDNotificationCenter defaultCenter] removeObserver:observer];
            //        observer = nil;
        });
    }];
    
    
    _readonlyProperty = @[@"can readonly property generate iVar?"];
}

///
/// 如果readonly的property，被重写了getter方法，则不会生成iVar了。
/// 同理，如果一个正常的property, setter和getter方法都被重写，则也不会生成iVar了。
///
//- (NSArray *)readonlyProperty {
//    return @[];
//}

- (void)test:(id)obj
{
    DDLog(@"test:::::   \n%@",obj) ;
    
    [[DDNotificationCenter defaultCenter] removeObserver:self] ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[DDNotificationCenter defaultCenter] postNotificationName:@"test" object:self userInfo:@{@"abc":@"dadong"}] ;
    [[DDNotificationCenter defaultCenter] postNotificationName:@"abc" object:self userInfo:@{@"abc":@"dadong"}] ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dd_reloadSelf];
    });
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}

@end
