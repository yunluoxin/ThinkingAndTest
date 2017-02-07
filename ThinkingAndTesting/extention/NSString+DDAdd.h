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
 是否不为空

 @return 是否不为空
 */
- (BOOL) isNotBlank ;


/**
 是否为空

 @return <#return value description#>
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

@end

NS_ASSUME_NONNULL_END
