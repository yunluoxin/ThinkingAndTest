//
//  NSObject+DDSerialization.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "NSObject+DDAddForSerialization.h"

@implementation NSObject (DDAddForSerialization)

@end

@implementation NSString (DDAddForSerialization)

- (id)dd_jsonObject {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) return nil;
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (![result isKindOfClass:[NSDictionary class]] && ![result isKindOfClass:[NSArray class]]) return nil;
    return result;
}

@end
