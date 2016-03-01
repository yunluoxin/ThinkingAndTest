//
//  DDUtils.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDUtils.h"

@implementation DDUtils
+ (NSDictionary *)convertAlipayResultStrToDic:(NSString *)alipayResultStr
{
    NSString *result = [DDUtils replaceUnicode:alipayResultStr];
    NSArray *array = [result componentsSeparatedByString:@"&"];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++ ) {
        NSString *str = array[i];
        NSRange range = [str rangeOfString:@"="];
        NSString *key = [str substringToIndex:range.location];
        NSString *value = [str substringFromIndex:range.location+1];
        key = [NSString stringWithFormat:@"\"%@\"",key];
        NSString *newStr = [NSString stringWithFormat:@"%@:%@",key,value];
        [arrayM addObject:newStr];
    }
    NSString *r = [arrayM componentsJoinedByString:@","];
    r = [NSString stringWithFormat:@"{%@}",r];
    
    return [NSJSONSerialization JSONObjectWithData:[r dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
@end
