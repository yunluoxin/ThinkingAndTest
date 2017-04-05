//
//  DDBaseCellConfig.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDBaseCellConfig.h"

@implementation DDBaseCellConfig

+ (instancetype)configWithTitle:(NSString *)title
                   propertyName:(NSString *)propertyName
                      realValue:(id)obj
                      tempValue:(id)stagingValue
                       cellType:(NSNumber *)cellType
                 cellIdentifier:(NSString *)identifier
                     cellHeight:(CGFloat)height
                   originalData:(id)originalData
{
    DDBaseCellConfig * instance = [[self alloc] init] ;
    instance.title = title ;
    instance.propertyName = propertyName ;
    instance.obj = obj ;
    instance.stagingValue = stagingValue ;
    instance.cellType = cellType ;
    instance.cellIdentifier = identifier ;
    instance.cellHeight = height ;
    instance.originalData = originalData ;
    return instance ;
}

@end
