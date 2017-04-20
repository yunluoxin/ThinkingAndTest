//
//  PasswordInputView.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/4/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordInputView : UIView
/**
 *  显示/隐藏 安全文本
 */
@property (assign, nonatomic)BOOL showSecurityText ;
/**
 *  最大输入长度（超出后输入无效）
 *  默认为0， 不限制
 */
@property (assign, nonatomic)NSUInteger maxInputLength ;





/**
 *  内部使用的真正文本输入控件
 */
@property (strong, nonatomic, readonly)UITextField * textField ;
/**
 *  内部使用的切换按钮，可自由设置图片（normal 和 selected）
 */
@property (strong, nonatomic, readonly)UIButton * switchBtn ;

@end
