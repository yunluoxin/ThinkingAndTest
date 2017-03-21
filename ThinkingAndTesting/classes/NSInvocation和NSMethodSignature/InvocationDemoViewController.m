//
//  InvocationDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "InvocationDemoViewController.h"

@interface InvocationDemoViewController ()

@end

@implementation InvocationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"NSInvocation Demo" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    NSMethodSignature * signature = [[self class] instanceMethodSignatureForSelector:@selector(test_A)] ;
    DDLog(@"%@",signature) ;
    
    NSMethodSignature * signature2 = [self methodSignatureForSelector:@selector(test_A)] ;
    DDLog(@"%@",signature2) ;
    
    /// I found ` signature == signature2 `
    
    
    /// 如果找不到此方法，则返回 nil
    /// NSMethodSignature 只有一个初始化方法， 就是` + (nullable NSMethodSignature *)signatureWithObjCTypes:(const char *)types; ` ，不能用alloc/init.
    ///
    /// @warning `+ instanceMethodSignatureForSelector` 和 `- methodSignatureForSelector` ，是继承于NSObject得来的方法，所有对象都拥有的，只能用自身类或者对象来调用
    ///           而不是用NSMethodSignature来调用!!! （NSMethodSignature本身也是对象！但是它找不到test_A方法，所以必定返回 nil）
    ///
    
    
    
    
/// Test A
    
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature] ;
    invocation.target = self ;
    invocation.selector = @selector(test_A) ;
    [invocation invoke] ;
    
    // either is ok.
//    [invocation invokeWithTarget:self] ;
    
    
    
    
    
/// Test B
    
    NSInvocation * invocation2 = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(test_B:)]] ;
    invocation2.selector = @selector(test_B:) ;
    NSString * str = @"哈哈大酸辣粉" ;
    [invocation2 setArgument:&str atIndex:2] ;      // 必须传对象地址！！！不能直接是对象
    [invocation2 invokeWithTarget:self] ;

    
    
    
    
/// Test C
    
    NSMethodSignature * sig3 = [self methodSignatureForSelector:@selector(test_C:addTo:)] ;
    NSInvocation * invocation3 = [NSInvocation invocationWithMethodSignature: sig3] ;
    invocation3.selector = @selector(test_C:addTo:) ;
    invocation3.target = self ;
    
    int a = 5 , b = 6 ;
    [invocation3 setArgument:&a atIndex:2] ;
    [invocation3 setArgument:&b atIndex:3] ;
    
    /// what use???
    int c = 3;
    [invocation3 setReturnValue:&c] ;
    
    [invocation3 invoke] ;
    
    DDLog(@"c == ? %d",c) ;
    
    int result = 0 ;
    [invocation3 getReturnValue:&result] ;
    
    DDLog(@"result = >%i",result) ;
    
    
    
/// Test D
    
    id res = [self useInvocation] ;
    
    DDLog(@"useInvocation - >%@",res );
    
}

- (void)test_A{
    DDLog(@"this is method test_A") ;
}


- (void)test_B:(NSString *)str
{
    DDLog(@"this is method test_B ,and parameters = > %@",str) ;
}


- (int)test_C:(int)a addTo:(int)b
{
    DDLog(@"this is method %s , %d + %d = %d",(void *)_cmd ,a, b, a + b) ;
    
    return a + b ;
}

- (NSObject *)test_D
{
    
    DDLog(@"this is method `test_D`") ;
    
    return [NSObject new] ;
}


// Test when the invocation result is a Object, what happens?
- (NSNumber *)useInvocation
{
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(test_D)]] ;
    
    invocation.selector = @selector(test_D) ;
    
    invocation.target = self ;
    
    [invocation invoke] ;
    
    ///
    /// @attention Here we have to use `__weak` or `__unsafe_unretained` , otherwise the code will crash for EXC_BAD_ACCESS.
    ///
    ///            But, WHY ???
    ///          `-getReturnValue' just copy the return value's address to the varible result, don't manage the memory. And by using `id result = nil' it means you have
    ///          a strong reference to the varible (that is, you have retained it). So when code execute out of the local range of method, it releases by default.
    ///          The real object is dead, once you use it, crash happens.
    ///
    __weak id result ;

    [invocation getReturnValue:&result] ;
    
    return result ;
}

@end
