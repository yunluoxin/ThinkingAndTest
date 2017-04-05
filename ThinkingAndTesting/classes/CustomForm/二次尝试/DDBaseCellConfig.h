//
//  DDBaseCellConfig.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDBaseCellConfig : NSObject
/**
 *  属性名
 */
@property (nonatomic, copy)NSString *propertyName;
/**
 *  实际值，上传form时候用的
 */
@property (nonatomic, strong)id obj ;

/**
 *  临时存放的值（为了存储方便. eg.当前格子是图片，但是上传的只是地址，这时候stagingValue就可以用来存实际显示的图片）
 */
@property (nonatomic, strong)id stagingValue ;

/**
 *  cell显示名
 */
@property (nonatomic, copy)NSString * title;

/**
 *  cellType
 */
@property (nonatomic, strong)NSNumber * cellType;

/**
 *  cell 的重用标识 （和cellType二选一用）
 */
@property (nonatomic, copy) NSString * cellIdentifier ;

/**
 *  cell的高度
 */
@property (nonatomic, assign)CGFloat cellHeight ;

/**
 *  原始的数据
 */
@property (nonatomic, strong)id  originalData ;


+ (instancetype)configWithTitle:(NSString *)title
                   propertyName:(NSString *)propertyName
                      realValue:(id)obj
                      tempValue:(id)stagingValue
                       cellType:(NSNumber *)cellType
                 cellIdentifier:(NSString *)identifier
                     cellHeight:(CGFloat)height
                   originalData:(id)originalData ;

@end
