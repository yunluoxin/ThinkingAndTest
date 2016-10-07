//
//  ParamGridView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.


//  >>>>>>>>>>>>>>商品参数的格子>>>>>>>>>>>>>>>>>>>>>

#import <UIKit/UIKit.h>

@interface ParamGridView : UIView
/**
 *  利用传入的键值对构造一个参数表格
 *
 *  @param dic 键值对
 *
 *  @return 一个创建好的表格，frame里面带有整个表格的大小
 */
- (instancetype)initWithDictionary:(NSDictionary *)dic ;

@end
