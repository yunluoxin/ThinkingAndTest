//
//  NSObject+Singleton.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NSObject+Singleton.h"

@implementation NSObject (Singleton)
+ (instancetype) sharedInstance
{
    static dispatch_once_t once ;
    static id obj = nil ;
    dispatch_once(&once, ^{
        obj = [[self alloc]init];
    });
    return obj ;
}
@end
