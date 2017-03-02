//
//  NSString+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSString+DDAdd.h"

@implementation NSString (DDAdd)

- (BOOL)isNotBlank
{
    if (self.length == 0 ) return NO ;
    NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet] ;
    for (int i = 0 ; i < self.length ; i ++)
    {
        unichar c = [self characterAtIndex:i] ;
        if (![set characterIsMember:c])
        {
            return YES ;
        }
    }
    return NO ;
}

- (BOOL)isBlank
{
    return ![self isNotBlank] ;
}

/**
 ios 8 之后，SDK已经有这个方法，则自动进行覆盖

 @param str 要测试的字符串
 @return 是否包含此字符串
 */
- (BOOL)containsString:(NSString *)str
{
    if (!str) return NO ;
    return [self rangeOfString:str].location != NSNotFound ;
}

- (BOOL)containsCharacterSet:(NSCharacterSet *)charSet
{
    if(charSet == nil) return NO ;
    return [self rangeOfCharacterFromSet:charSet].location != NSNotFound ;
}
@end