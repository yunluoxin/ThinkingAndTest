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

/**
 *  从fromVC开始，当前最顶端的控制器
 *
 *  @param fromVC 从这个vc开始算
 *
 *  @return 当前最顶端的控制器
 */
+ (UIViewController *)currentMostTopControllerFromController:(UIViewController *)fromVC ;

@end


@interface DDUtils (Base64)

/**
 image - > Base64String
 */
+ (NSString *)base64StringFromImage:(UIImage *)image ;

/**
 Base64String - > image
 */
+ (UIImage *)imageFromBase64String:(NSString *)base64String ;
//** @param scale base64String里面包含的图片的scale */
+ (UIImage *)imageFromBase64String:(NSString *)base64String scale:(CGFloat)scale ;

/**
 data - > Base64String
 */
+ (NSString *)base64StringFromData:(NSData *)data ;

/**
 Base64String - > data
 */
+ (NSData *)dataFromBase64String:(NSString *)base64String ;

@end
