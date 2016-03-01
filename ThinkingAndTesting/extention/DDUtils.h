//
//  DDUtils.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.



//  -------------------工具类------------------------

#import <Foundation/Foundation.h>

@interface DDUtils : NSObject
/**
 *  将支付宝成功支付后的dic中的result的字符串转换成字典
 *
 *  @param alipayResultStr result字符串
 *
 *  @return 字典
 */
+ (NSDictionary *)convertAlipayResultStrToDic:(NSString *)alipayResultStr ;

/**
 *  将string中的unicode字符串转换成中文
 *
 *  @param unicodeStr 需要转换的string
 *
 *  @return 转换后的字符串
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr ;
@end
