//
//  KVO_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "KVO_ViewController.h"
#import "KVO_Object.h"
#import "SelfImplementationKVO_Demo_ViewController.h"

#import "DDUtils+HookInstance.h"

#import <objc/runtime.h>

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
    
    UIViewController * vc = [SelfImplementationKVO_Demo_ViewController new] ;
    [DDUtils hookInstance:vc originalSel:@selector(viewWillAppear:) withTargetSel:@selector(hook_viewWillAppear:)] ;
    [self dd_navigateTo:vc] ;
}



#pragma mark - block test

- (void)testBlock:(NSString *)obj number:(int)num
{
    DDLog(@"Yuan来的testBlock方法「」") ;
}

- (void)tryBlockToImpl
{
    ///
    /// 注意，没有_cmd, 传参只有（self， args...） ,和普通的imp不一样
    ///
    void (^block)(id, id, int) = ^(id self, id obj, int a){
        DDLog(@"%@ int = > %d",obj, a) ;
        DDLog(@"%@",NSStringFromSelector(_cmd)) ;
    } ;
    
    
    
    IMP imp = (IMP)imp_implementationWithBlock(block);
    
    [DDUtils hookInstance:self originalSel:@selector(testBlock:number:) replaceWith:imp] ;
    
    [self testBlock:@"哈哈" number:5] ;
    
    /// 用好之后还必须移除
    imp_removeBlock(imp) ;
}


#pragma mark - 带返回值的Hook

- (void)tryHookMethodWhichHavingReturnValue
{
    [DDUtils hookInstance:self originalSel:@selector(sumA:andB:) withTargetSel:@selector(hook_sumA:andB:)] ;
    
    int result = [self sumA:5 andB:8] ;
    
    DDLog(@"after hooking, the result is %d", result) ;
}

- (int)sumA:(int)a andB:(int)b
{
    DDLog(@"%d + %d = %d",a, b, a+b) ;
    return a + b ;
}

- (int)hook_sumA:(int)a andB:(int)b
{
    int result = [self hook_sumA:a andB:b] ;
    
    DDLog(@"hook success!") ;
    
    return result + 1 ;
}


/// 用这个不行！！！看出MethodSignature必须相符合！ 不然会出错的、！
- (void)hook2_sumA:(int)a andB:(int)b
{
    DDLog(@"hook success!") ;
    
    [self hook_sumA:a andB:b] ;
    
    return  ;
}


- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context;
{
    NSLog(@"%@",change) ;
}

@end
