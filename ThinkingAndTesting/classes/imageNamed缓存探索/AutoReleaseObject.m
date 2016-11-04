//
//  AutoReleaseObject.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/31.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AutoReleaseObject.h"

@implementation AutoReleaseObject

+ (instancetype)sharedInstance
{
    AutoReleaseObject * obj = [[AutoReleaseObject alloc] init] ;
    return obj ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}
@end
