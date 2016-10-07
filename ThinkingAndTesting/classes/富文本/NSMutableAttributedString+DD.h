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
@end
