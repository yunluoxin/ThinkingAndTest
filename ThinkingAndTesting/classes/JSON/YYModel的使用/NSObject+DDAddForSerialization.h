//
//  NSObject+DDSerialization.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DDAddForSerialization)

@end

@interface NSString (DDAddForSerialization)

/**
 把json字符串 -> 字典或者数组

 @return NSArray或者NSDictionary
 */
- (id)dd_jsonObject;

@end
