//
//  ProductAmoutChangeView.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/5/22.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//  改变商品数量的加减条
//
@class ProductAmoutChangeView ;

@protocol ProductAmountChangeViewDelegate <NSObject>
@optional
- (void)productAmountChangeView:(ProductAmoutChangeView *)view didChangeToNum:(NSUInteger)number ;
@end

@interface ProductAmoutChangeView : UIView
/**
 *  最大购买数量
 */
@property (nonatomic, assign) NSUInteger maxNumber ;
/**
 *  最小购买数量
 */
@property (nonatomic, assign) NSUInteger minNumber ;

/**
 *  当前数量
 */
@property (nonatomic, assign) NSInteger currentNumber ;


@property (weak, nonatomic) id <ProductAmountChangeViewDelegate> delegate ;
@end
