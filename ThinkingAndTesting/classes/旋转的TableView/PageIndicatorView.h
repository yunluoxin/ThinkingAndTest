//
//  PageIndicatorView.h
//  kachemama
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
//
//  轮播图等可用的 当前页数/总页数 指示器
//  @warning 内部没有判断当前页数是否小于总页数等问题，外部自行判断
//
@interface PageIndicatorView : UIView

/**
 *  总共数量
 */
@property (assign, nonatomic)NSUInteger totalNum ;

/**
 *  当前数量
 */
@property (assign, nonatomic)NSUInteger currentNum ;

/**
 *  只有一页时候是否隐藏。 Default: NO
 */
@property (assign, nonatomic)BOOL hideForSinglePage ;

+ (instancetype)pageIndicatorView ;

@end
