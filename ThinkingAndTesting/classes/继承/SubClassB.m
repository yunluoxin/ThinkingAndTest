//
//  SubClassB.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/29.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "SubClassB.h"

@implementation SubClassB

- (void)parentMethodA
{
    [super parentMethodA] ;
    
    DDLog(@"子类方法A") ;
    
    [self parentMethodB] ;
}


- (void)parentMethodB
{
    DDLog(@"子类方法B") ;
}
@end
