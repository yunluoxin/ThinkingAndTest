//
//  ProgressHUD.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/6.
//  Copyright © 2017年 dadong. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject

+ (instancetype)shared ;

// those methods that don't constain animated arg, mean that animated is YES .
+ (void)dismiss ;
+ (void)dismissAnimated:(BOOL)animated ;
+ (void)dismissAfter:(NSTimeInterval)timeInterval ;
+ (void)dismissAfter:(NSTimeInterval)timeInterval animated:(BOOL)animated ;

// will not dismiss automatically. we should use `+ dismiss` or `+ dismissAnimated:` etc. to dismiss.
+ (void)show:(NSString *)status ;

// show a large UIActivityIndicator and the message on the bottom, obviously not dismiss automatically.
+ (void)showLoading:(NSString *)status ;

// use a internal style to indicate success, not dismiss automatically.
+ (void)showSuccess:(NSString *)status ;
// dismiss after xx seconds. default use animation.
+ (void)showSuccess:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval ;

// use a internal style to indicate error, not dismiss automatically.
+ (void)showError:(NSString *)status ;
// dismiss after xx seconds. default use animation.
+ (void)showError:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval ;

@end


#ifndef DD_Deprecated_iOS
#define DD_Deprecated_iOS(description) __attribute__((deprecated(description)))
#endif

// for compatibility with code worte before, don't use them from now on.
@interface ProgressHUD (DD_Deprecated)

+ (void)show:(NSString *)status Interaction:(BOOL)Interaction DD_Deprecated_iOS("Use show:") ;

+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction DD_Deprecated_iOS("Use showStatus:");

+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction DD_Deprecated_iOS("Use showError:");

@end
