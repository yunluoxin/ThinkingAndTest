//
//  NSArray+DDAdd.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/12.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DDAdd)

/**
 反转数组

 @return 返回反转顺序后端数组
 */
- (NSArray *)reverse;

///
/// @test 测试用的
/// @example 速度没有上面的快！在1000个数据下，上面的耗时0.000813s，下面的耗时0.003291s， 上面的快3-4倍
///
- (NSArray *)reverse2;

@end
