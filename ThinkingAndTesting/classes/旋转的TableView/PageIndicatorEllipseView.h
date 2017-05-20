//
//  PageIndicatorEllipseView.h
//  kachemama
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

///
/// 仿京东的。 在产品列表页面滚动时候，指示当前是第几页的指示器 （椭圆形的）
///
@interface PageIndicatorEllipseView : UIView
/**
 *  总共数量
 */
@property (assign, nonatomic)NSUInteger totalNum ;

/**
 *  当前数量
 */
@property (assign, nonatomic)NSUInteger currentNum ;

+ (instancetype)pageIndicatorEllipseView ;

@end
