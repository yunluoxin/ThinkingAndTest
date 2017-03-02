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

+ (UIViewController *)currentMostTopControllerFromController:(UIViewController *)fromVC
{
    UIViewController *mainVC = fromVC ;
    
    if (!mainVC) {
        mainVC = [UIApplication sharedApplication].keyWindow.rootViewController ;
    }

    if ([mainVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)mainVC ;
        mainVC = tabVC.selectedViewController ;
    }
    
    if ([mainVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)mainVC ;
        mainVC = navVC.topViewController ;
    }
    
    if ([mainVC isKindOfClass:[UIViewController class]] && [mainVC isKindOfClass:[UINavigationController class]] == NO && [mainVC isKindOfClass:[UITabBarController class]] == NO) {
        if (mainVC.presentedViewController  == nil ) {
            return mainVC ;
        }
        mainVC = mainVC.presentedViewController ;
    }
    return [self currentMostTopControllerFromController:mainVC] ;
}
@end


@implementation DDUtils (Base64)

+ (UIImage *)imageFromBase64String:(NSString *)base64String
{
    if (!base64String || base64String.length < 1) {
        return nil ;
    }
    NSData * data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters] ;
    UIImage * image = [[UIImage alloc] initWithData:data] ;
    return image ;
}

+ (UIImage *)imageFromBase64String:(NSString *)base64String scale:(CGFloat)scale
{
    if (!base64String || base64String.length < 1 || scale < 1) {
        return nil ;
    }
    NSData * data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters] ;
    UIImage * image = [[UIImage alloc] initWithData:data scale:scale] ;
    return image ;
}

+ (NSString *)base64StringFromImage:(UIImage *)image
{
    if (!image) {
        return nil ;
    }
    NSData * data = UIImagePNGRepresentation(image) ;
    NSString * str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] ;
    return str ;
}

+ (NSString *)base64StringFromData:(NSData *)data
{
    if (data == nil) {
        return nil ;
    }
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] ;
}

+ (NSData *)dataFromBase64String:(NSString *)base64String
{
    if (!base64String || base64String.length < 1) {
        return nil ;
    }
    NSData * data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters] ;
    return data ;
}

@end
