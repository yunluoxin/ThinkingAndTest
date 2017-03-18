//
//  NSMutableAttributedString+DD.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NSMutableAttributedString+DD.h"

@implementation NSMutableAttributedString (DD)

+ (instancetype) attributedStringWithString:(NSString *)str rangeStringAttributes:(NSDictionary <NSString*, NSDictionary<NSString *, id>*>*) dic
{
    return [[self alloc]initWithString:str rangeStringAttributes:dic];
}

- (instancetype)initWithString:(NSString *)str rangeStringAttributes:(NSDictionary <NSString*, NSDictionary<NSString *, id>*>*) dic
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    for (NSString *rangeStr in dic.allKeys) {
        NSDictionary *tempDic = dic[rangeStr];
        NSRange range = [str rangeOfString:rangeStr];
        [attrStr addAttributes:tempDic range:range];
    }
    return attrStr ;
}

- (void)removeAttribute:(NSString *)name rangeString:(NSString *)rangeStr
{
    [self removeAttribute:name range:[self.string rangeOfString:rangeStr]];
}

- (void)addAttributes:(NSDictionary<NSString *,id> *)attrs rangeStrings:(NSArray *)rangeStrings
{
    if (!rangeStrings || rangeStrings.count < 1) return ;
    
    for (NSString * rangeString in rangeStrings) {
        NSRange range = [self.string rangeOfString:rangeString] ;
        if (range.location != NSNotFound) {
            [self addAttributes:attrs range:range] ;
        }
    }
}

@end
