//
//  MessageView.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/27.
//  Copyright © 2016年 dadong. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MessageView : UIImageView

/**
 *  根据字体大小创建一个自适应的小圆点
 *
 *  @param fontSize 消息数字的字体
 *
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize ;

/**
 *  消息数 
 *  > 99 自动变成 "99+"
 */
@property (nonatomic, copy) NSString * messageNum ;

/**
 *  消息数字的颜色，前景色
 */
@property (nonatomic, strong) UIColor * messageNumColor ;


/**
 *  消息的背景颜色
 */
@property (nonatomic, strong) UIColor * messageBackgroundColor ;

@end
