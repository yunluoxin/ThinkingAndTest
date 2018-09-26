//
//  DDUtils+Test.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/30.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDUtils.h"

@interface DDUtils (Test)

+ (void)kaoYa ;

/**
 *  @result     不行！！！ 调用下面的方法崩溃！
 *  @conclusion 在Category里，是无法通过property生成方法实现的！***都必须手动增加方法实现！下面这句话只能增加选择子(selector)!***
 */
@property (copy, nonatomic)NSString *name ;

@end
