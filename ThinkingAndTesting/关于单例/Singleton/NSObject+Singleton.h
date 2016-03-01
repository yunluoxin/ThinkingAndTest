//
//  NSObject+Singleton.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

/*
 
   只要把此头文件
   =================================>>>>>  #import "NSObject+Singleton.h"
   放在想要实现单例的对象.h文件里即可。
 
 */

#import <Foundation/Foundation.h>

@interface NSObject (Singleton)
/**
 *  获得一个单例对象（只要通过此方法调用的获得的对象是同一个，线程安全）
 *
 *  @return 一个实例
 */
+ (instancetype) sharedInstance ;
@end
