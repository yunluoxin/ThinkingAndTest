//
//  NSString+ClassBelonged.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/2.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NSString+ClassBelonged.h"

@implementation NSString (ClassBelonged)
+ (void)test
{
    DDLog(@"NSString是否是自己的子类%d",[self isSubclassOfClass:[NSString class]]);   //Answer:是
}
@end
