//
//  DDBaseViewController.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDProgressHUD.h"

@interface DDBaseViewController : UIViewController

/**
 通过这个属性设置状态栏风格，会自动在离开页面后进行还原
 @warning 必须在viewWillAppear之前设置
 */
@property (assign, nonatomic)UIStatusBarStyle statusBarStyle ;
- (BOOL)isStatusBarVisible ;
- (void)hideStatusBarAnimated:(BOOL)animated ;
- (void)showStatusBarAnimated:(BOOL)animated ;

- (BOOL)isNavigationBarVisible ;
- (void)hideNavigationBarAnimated:(BOOL)animated ;
- (void)showNavigationBarAnimated:(BOOL)animated ;
- (void)showNavigationBarBottomLine ;

- (BOOL)isModal ;


///
/// keyboard event handle
///

/**
 是否需要处理键盘事件
 @warning 请在viewWillAppear之前就设置好此参数
 */
@property (assign, nonatomic)BOOL handleKeyboardEvent ;
/** 当前键盘相对于屏幕的frame,只有handleKeyboardEvent开启时候才有效 */
@property (assign, nonatomic, readonly)CGRect keyboardFrame_relatedToScreen ;
- (void)onKeyboardWillShow:(NSNotification *)notification ;
- (void)onKeyboardDidShow:(NSNotification *)notification ;
- (void)onKeyboardWillHide:(NSNotification *)notification ;
- (void)onKeyboardDidHide:(NSNotification *)notification ;


///
///    show tips
///
- (XDProgressHUD *)showLoadingWithText:(NSString *)text ;
- (XDProgressHUD *)showSuccessWithText:(NSString *)text ;
- (XDProgressHUD *)showErrorWithText:(NSString *)text ;
- (XDProgressHUD *)showText:(NSString *)text ;
- (void)dismissAllHuds ;
- (void)dismissAllHudsAfter:(NSTimeInterval)seconds ;

@end
