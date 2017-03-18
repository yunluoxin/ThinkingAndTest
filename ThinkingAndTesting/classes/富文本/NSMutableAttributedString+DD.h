//
//  NSMutableAttributedString+DD.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (DD)

+ (instancetype) attributedStringWithString:(NSString *)str rangeStringAttributes:(NSDictionary <NSString*, NSDictionary<NSString *, id>*>*) dic ;

- (instancetype) initWithString:(NSString *)str rangeStringAttributes:(NSDictionary <NSString*, NSDictionary<NSString *, id>*>*) dic ;

- (void)removeAttribute:(NSString *)name rangeString:(NSString *)rangeStr ;

/**
 给一些指定的字符，添加样式
 @param attrs 样式
 @param rangeStrings 想要添加样式的字符串 数组
 */
- (void)addAttributes:(NSDictionary<NSString *,id> *)attrs rangeStrings:(NSArray *)rangeStrings ;
@end
