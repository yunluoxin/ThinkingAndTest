//
//  ParentClassA.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/29.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ParentClassA.h"

@implementation ParentClassA

-  (void)parentMethodA
{
    DDLog(@"这是父类方法A") ;
    
    [self parentMethodB] ;
}

- (void)parentMethodB
{
    DDLog(@"这是父类方法B") ;
}

@end
