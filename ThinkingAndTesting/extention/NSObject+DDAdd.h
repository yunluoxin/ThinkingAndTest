//
//  NSObject+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DDAdd)

/**
 对当前对象设置一个键值，强引用，retain
 */
- (void)setAssociateValue:(id)value forKey:(const void *) key ;

/**
 通过key获取到之前保存的value
 */
- (id)getAssociateValueByKey:(const void *)key ;

/**
 对当前对象设置一个键值，但是值是弱引用
 */
- (void)setAssociateWeakValue:(id)value forKey:(const void *)key ;

/**
    移除所有通过runtime设置的值
 */
- (void)removeAllAssociateValues ;

@end
