//
//  SelfImplementationKVO_Demo_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/24.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "SelfImplementationKVO_Demo_ViewController.h"

#import "NSObject+KVO_Implementation.h"
#import "KVO_Object.h"

@interface SelfImplementationKVO_Demo_ViewController ()
{
    KVO_Object * _obj ;
}
@end

@implementation SelfImplementationKVO_Demo_ViewController

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]) {
        _obj = [KVO_Object new] ;
    }
    return self ;
}

- (void)dealloc
{
    NSLog(@"%s",__func__) ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"SelfImplementationKVO" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    [_obj dd_addObserver:self forKeyPath:@"name" withBlock:^(NSString *keyPath, id observer, id oldValue, id newValue) {
        DDLog(@"%@, %@, %@, %@",keyPath, observer, oldValue, newValue) ;
    }] ;
    
    [_obj dd_addObserver:self forKeyPath:@"test" withBlock:^(NSString *keyPath, id observer, id oldValue, id newValue) {
        DDLog(@"%@, %@, %@, %@",keyPath, observer, oldValue, newValue) ;
    }] ;
    
    KVO_Object * o = [KVO_Object new] ;
    o.name = @"sdajflasdjf" ;

}

- (void)test
{
    DDLog(@"%@,%s",self,__func__) ;
}

#pragma mark - actions
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss" ;
    _obj.name = [formatter stringFromDate:[NSDate date]] ;
    
    [_obj setValue:@(5) forKey:@"test"] ;
}

#pragma mark - private methods

- (void)hook_viewWillAppear:(BOOL)animated
{
    DDLog(@"%s",__func__) ;
    
    [self hook_viewWillAppear:animated] ;
}

@end
