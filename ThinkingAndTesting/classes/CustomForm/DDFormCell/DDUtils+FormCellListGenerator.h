//
//  DDUtils+FormCellListGenerator.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDUtils.h"

@interface DDUtils (FormCellListGenerator)

+ (void)generatePlistWithObject:(id)obj toFile:(NSString *)path ;

/**
 *  把对象序列化成字典或者数组类型
 *
 *  @param obj 要序列化的对象
 *
 *  @return 字典或者数据
 */
+ (id)serializationWithObject:(id)obj ;
@end
