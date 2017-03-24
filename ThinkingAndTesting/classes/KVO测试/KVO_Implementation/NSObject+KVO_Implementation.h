//
//  NSObject+KVO_Implementation.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/24.
//  Copyright © 2017年 dadong. All rights reserved.
//

///
/// 模拟KVO的实现. reference http://tech.glowing.com/cn/implement-kvo/
/// 等锁熟悉了。需要把这个改成线程安全的！
///


#import <Foundation/Foundation.h>

typedef void (^DDKVOCallBack)(NSString * keyPath, id observer, id oldValue, id newValue);

@interface NSObject (KVO_Implementation)

//- (void)dd_addObserver:(id)observer forKeyPath:(NSString *)keyPath withBlock:(void (^)(NSString * keyPath, id observer, id oldValue, id newValue))block ;
- (void)dd_addObserver:(id)observer forKeyPath:(NSString *)keyPath withBlock:(DDKVOCallBack)block ;

- (void)dd_removeObserver:(id)observer forKeyPath:(NSString *)keyPath ;

@end
