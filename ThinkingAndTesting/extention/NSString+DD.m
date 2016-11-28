//
//  NSString+DD.m
//  卡车妈妈
//
//  Created by 张小冬 on 15/12/22.
//  Copyright © 2015年 张小东. All rights reserved.
//
/*
 DDLog(@"dd--->%d",[@"dd" isNumberWithLength:5]);
 DDLog(@"空格--->%d",[@" 5" isNumberWithLength:5]);
 DDLog(@"46ab33--->%d",[@"46ab333" isNumberWithLength:5]);
 DDLog(@"4633--->%d",[@"4633" isNumberWithLength:5]);
 DDLog(@"12345a--->%d",[@"12345a" isNumberWithLength:5]);
 DDLog(@"12345a--->%d",[NSString verifyString:@"12345a" isNumberWithLength:5]);
 
 DDLog(@"adf@qq.com--->%d",[@"adf@qq.com" validMail]);
 DDLog(@"adf@qq.com.cn--->%d",[@"adf@qq.com.cn" validMail]);
 DDLog(@"adf@qq.cn--->%d",[@"adf@qq.cn" validMail]);
 DDLog(@"@qq.com--->%d",[@"@qq.com" validMail]);
 DDLog(@"ad@f@qq.com--->%d",[@"ad@f@qq.com" validMail]);
 DDLog(@"ad@q.q.com--->%d",[@"ad@q.q.com" validMail]);
 DDLog(@"a3d@qq.com--->%d",[@"a3d@qq.com" validMail]);
 DDLog(@"a*d@qq.com--->%d",[@"a*d@qq.com" validMail]);
 
 DDLog(@"18758988185--->%d",[@"18758988185" validPhone]);
 DDLog(@"187589881853--->%d",[@"187589881853" validPhone]);
 DDLog(@"28758988185--->%d",[@"28758988185" validPhone]);
 DDLog(@"218758988185--->%d",[@"218758988185" validPhone]);
 */
#import "NSString+DD.h"

@implementation NSString (DD)
- (BOOL)isBlank
{
    if (!self||self.length==0) {
        return YES ;
    }
    BOOL flag = YES ;
    if (self.length >= 1) {
        for (int i = 0 ;i<self.length ;i++) {
           unichar c = [self characterAtIndex:i];
            if (!(c == ' ')) {
                flag = NO ;
                break;
            }
        }
    }
    return flag ;
}

+ (BOOL)isBlank:(NSString *)str
{
    if (!str) {
        return YES ;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES ;
    }
    return [str isBlank];
    
}
- (BOOL)validPhone
{
    if ([self isBlank]) {
        return NO ;
    }
    if (!(self.length==11)) {
        return NO ;
    }
    //正则匹配
    NSString *reg = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    return [predicate evaluateWithObject:self] ;
}
- (BOOL)validMail
{
    if ([self isBlank]) {
        return NO ;
    }
    NSString *reg = @"^\\w+@\\w+\\.((com(\\.cn)?)|(cn)|(net)|(org))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    return [predicate evaluateWithObject:self] ;
}

- (CGSize)sizeOfFont:(UIFont *)font maxWidth:(CGFloat)max_width maxHeight:(CGFloat)max_height
{
    if (IOS_7_OR_LATER) {
        //ios_7之后的
        NSDictionary *dic = @{
                              NSFontAttributeName:font,
                              NSForegroundColorAttributeName:[UIColor blackColor]
                              };
        return [self boundingRectWithSize:CGSizeMake(max_width, max_height) options:1 attributes:dic context:nil].size;
    }else{
        //ios_7之前的
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(max_width, max_height) lineBreakMode:NSLineBreakByTruncatingTail];
    }
}

- (NSURL *)imageURLWithWidth:(CGFloat)width height:(CGFloat)height
{
    if (width >0 && height > 0) {
        int w = (int)(width * IOS_SCALE);
        int h = (int)(height * IOS_SCALE);
        NSString * urlStr = [self stringByAppendingFormat:@"@1wh_1e_1c_0o_01_%dh_%dw_100q",w,h ];
        return [NSURL URLWithString:urlStr];
    }
    return [NSURL URLWithString:self];
}

+ (NSURL *)imageWithURL:(NSString *)urlStr width:(CGFloat)width height:(CGFloat)height
{
    return [urlStr imageURLWithWidth:width height:height];
}



- (BOOL)isNumberWithLength:(int) count
{
    if (count < 1) {
        return NO ;
    }
    if (![self isKindOfClass:[NSString class]]) {
        return NO ;
    }
    NSString *regX = [NSString stringWithFormat:@"^\\d{%d}$",count];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regX];
    return [predicate evaluateWithObject:self];
}

+ (BOOL)verifyString:(NSString *)str isNumberWithLength:(int)count
{
    if ([self isBlank:str]) {
        return NO ;
    }
    return [str isNumberWithLength:count];
}
@end

@implementation NSString (Log)
+ (NSString *)dd_dateString
{
    static NSDateFormatter *dateFormatter = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init] ;
    });
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

@end
