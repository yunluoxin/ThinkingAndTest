//
//  Cat.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "Cat.h"

@interface Cat ()

@property (nonatomic, strong, readwrite) NSString * readOnlyString ;        //必须写上readwrite,和.h中写上readonly才可以编译！！！

@end

@implementation Cat
- (void)eat
{
    DDLog(@"cat可以吃饭") ;
}

- (void)run
{
    DDLog(@"cat可以跑步") ;
}

- (void)walk
{
    DDLog(@"cat可以走路") ;
}

- (BOOL)isCute
{
    DDLog(@"猫很可爱" );
    return YES ;
}


- (void)test
{
    DDLog(@"测试得到私有变量的值是%@",_privateVar) ;
    
//    [Cat test2:@1] ;
    SEL selector = NSSelectorFromString(@"test2:");
    
//    [Cat performSelector:selector withObject:nil] ;
    [self performSelector:selector withObject:nil] ;
    
}

- (void)test2:(id)anything
{
    DDLog(@"%@",NSStringFromSelector(_cmd));
}
@end
