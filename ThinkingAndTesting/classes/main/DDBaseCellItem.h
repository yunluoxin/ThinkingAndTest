//
//  DDBaseItem.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDBaseCellItem : NSObject
/**
 *  cell类型，待指定枚举
 */
@property (assign, nonatomic)NSInteger cellType ;
/**
 *  通用的代理
 */
@property (weak, nonatomic) id delegate ;
/**
 *  通用的数据
 */
@property (strong, nonatomic)id obj ;

@property (assign , nonatomic)CGFloat cellHeight ;
@property (  copy , nonatomic)NSString * cellIdentifier ;

@property (assign , nonatomic)BOOL hasBottomLine ;
@property (assign , nonatomic)BOOL hasTopLine ;
@property (assign , nonatomic)CGFloat bottomLineIndent ;
@property (assign , nonatomic)CGFloat topLineIndent ;
@property (strong , nonatomic)UIColor * topLineColor ;
@property (strong , nonatomic)UIColor * bottomLineColor ;


@property (assign, nonatomic)BOOL isFirstOne ;
@property (assign, nonatomic)BOOL isLastOne ;

@property (assign, nonatomic)BOOL canHighlight ;
@end
