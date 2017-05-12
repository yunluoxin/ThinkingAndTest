//
//  DDUtils+Security.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/5.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDUtils.h"

@interface DDUtils (Security)

/**
 *  MD5加密 16位
 *
 *  @param input 要加密的字符串
 *
 *  @return 加密后的文本
 */
+ (NSString *)encrypt_MD5:(NSString *)input ;


/**
 
 String => Base64String
 
 @param input 字符串
 @return base64加密后的字符串
 */
+ (NSString *)encode_base64:(NSString *)input ;

/**
 
 Base64String => String
 
 @param input 加密后的字符串
 @return 原来字符串
 */
+ (NSString *)decode_base64:(NSString * )input ;
@end
