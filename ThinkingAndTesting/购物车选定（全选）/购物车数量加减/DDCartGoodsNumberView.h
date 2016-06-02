//
//  DDCartGoodsNumberView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/2.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCartGoodsNumberView : UIView
/**
 *  最大购买数量
 */
@property (nonatomic, assign) NSInteger maxNumber ;
/**
 *  最小购买数量
 */
@property (nonatomic, assign) NSInteger minNumber ;

/**
 *  当前数量
 */
@property (nonatomic, assign) NSInteger currentNumber ;
@end
