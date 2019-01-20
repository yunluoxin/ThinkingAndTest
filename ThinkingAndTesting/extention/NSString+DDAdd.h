//
//  NSString+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (DDAdd)

/**
 判断字符串否不为空

 @return 是否不为空
 */
- (BOOL) isNotBlank ;


/**
 判断字符串是否为空

 @return 字符串是否为空
 */
- (BOOL) isBlank ;
/**
 ios 8 之后，SDK已经有这个方法，则自动进行覆盖
 
 @param str 要测试的字符串
 @return 是否包含此字符串
 */
- (BOOL) containsString:(NSString *)str ;


/**
 是否包含某字符集中的任何一个字符

 @param charSet 字符集
 @return 是否包含字符集中的任何一个字符
 */
- (BOOL) containsCharacterSet:(NSCharacterSet *)charSet ;

/**
 取A和B之间的字符串，顺序为从左到右
 @param beginString 开始字符串
 @param endString 结束字符串
 @return 夹在中间的字符串
 */
- (NSString *)substringBetweenA:(NSString *)beginString andB:(NSString *)endString;

@end

@interface NSString (Reconstruct)

/**
 反转字符串

 @return 逆序的字符串
 */
- (NSString *)reverse;


/**
 @test 测试用的
 
 比上面的速度慢，10000个字符组成的字符串，上面耗时0.000459s，下面耗时0.000762s，接近两倍
 */
- (NSString *)reverse2;

@end

NS_ASSUME_NONNULL_END
