//
//  NSData+AES.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/9/29.
//  Copyright © 2020 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES)
- (nullable NSData *)AES256DecryptWithKey:(NSString *)key iv:(NSString *)iv;

- (nullable NSData *)AES256EncryptWithKey:(NSString *)key iv:(NSString *)iv;
@end

NS_ASSUME_NONNULL_END
