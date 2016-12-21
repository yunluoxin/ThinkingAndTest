//
//  KVO_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "KVO_ViewController.h"
#import "KVO_Object.h"

@interface KVO_ViewController ()
{
    KVO_Object * _obj ;
}

@end

@implementation KVO_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _obj = [KVO_Object new] ;
    
    [_obj addObserver:self forKeyPath:@"test" options:NSKeyValueObservingOptionNew context:nil] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_obj setValue:@(3) forKey:@"test"] ;
}



- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context;
{
    NSLog(@"%@",change) ;
}

@end
