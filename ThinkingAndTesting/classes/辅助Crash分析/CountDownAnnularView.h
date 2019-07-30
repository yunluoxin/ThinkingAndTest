//
//  CountDownAnnularView.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/30.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CountDownAnnularView;

typedef void (^GestureTapCallBack)(CountDownAnnularView *);

/**
 环形的倒计时视图
 */
@interface CountDownAnnularView : UIView
@property (nonatomic, strong) UIColor *annularBgColor;  /**< 环的背景颜色 */
@property (nonatomic, strong) UIColor *progressColor;   /**< 进度的颜色 (环的前景颜色) */
@property (nonatomic, assign) CGFloat annularWidth;     /**< 环的宽度 */

@property (nonatomic, assign) UIFont *titleFont;        /**< 倒计时文字的字体 */
@property (nonatomic, strong) UIColor *titleColor;      /**< 倒计时文字的颜色 */
@property (nonatomic,   copy) NSString *titleFormat;    /**< 倒计时文字的格式. eg: @"%ds", 则中间label显示3s,2s,1s */
@property (nonatomic, assign) NSInteger countDownFrom;  /**< 从哪个数字开始倒计时 (默认倒计时到0)， 如果不设置，则没有倒计时文字 */

/**
 开始倒计时
 */
- (void)start;

/**
 结束倒计时
 */
- (void)stop;

/**
 点击了整个倒计时视图的回调
 */
@property (nonatomic, copy) GestureTapCallBack gestureTapCallBack;

@end

NS_ASSUME_NONNULL_END
