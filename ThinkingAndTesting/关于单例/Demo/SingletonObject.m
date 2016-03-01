//
//  SingletonObject.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "SingletonObject.h"

@implementation SingletonObject

+ (instancetype)sharedObject
{
    static dispatch_once_t once ;
    static id obj = nil ;
    dispatch_once(&once, ^{
        obj = [[self alloc]init];
    });
    return obj ;
}

- (instancetype)initWithAge:(int)age
{
//    self = [[self class]sharedObject];
//    self.age = age ;
    if (self = [super init]) {
        self.age = age ;
    }
    return self ;
}
@end
