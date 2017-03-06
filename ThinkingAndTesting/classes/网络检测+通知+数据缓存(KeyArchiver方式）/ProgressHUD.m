//
//  ProgressHUD.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ProgressHUD.h"
#import <MBProgressHUD.h>

@interface ProgressHUD ()<MBProgressHUDDelegate>

/**
 *  maintain a internal hud instance .
 */
@property (nonatomic, strong)MBProgressHUD * hud ;

@end

@implementation ProgressHUD

+ (instancetype)shared
{
    static id instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init] ;
    });
    return instance ;
}


#pragma mark - api M

+ (void)show:(NSString *)status
{
    [[self shared] show:status dismissAfter:0] ;
}

+ (void)showLoading:(NSString *)status
{
    [[self shared] showLoading:status] ;
}

+ (void)showSuccess:(NSString *)status
{
    [self showSuccess:status dismissAfter:0] ;
}

+ (void)showSuccess:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval
{
    [[self shared] showStatus:status image:[UIImage imageNamed:@"progresshud-success@2x"] dismissAfter:timeInterval] ;
}

+ (void)showError:(NSString *)status
{
    [self showError:status dismissAfter:0] ;
}

+ (void)showError:(NSString *)status dismissAfter:(NSTimeInterval)timeInterval
{
    [[self shared] showStatus:status image:[UIImage imageNamed:@"progresshud-error@2x"] dismissAfter:timeInterval] ;
}

+ (void)dismiss
{
    [self dismissAnimated:YES] ;
}

+ (void)dismissAnimated:(BOOL)animated
{
    [self dismissAfter:0 animated:animated] ;
}

+ (void)dismissAfter:(NSTimeInterval)timeInterval
{
    [self dismissAfter:timeInterval animated:YES] ;
}

+ (void)dismissAfter:(NSTimeInterval)timeInterval animated:(BOOL)animated
{
    [[self shared] dismissAnimated:animated after:timeInterval] ;
}


#pragma mark - private Methods

- (void)showStatus:(NSString *)status image:(UIImage *)image dismissAfter:(NSTimeInterval)time
{
    if (_hud) [self p_removeHud] ;
        
    self.hud.mode = MBProgressHUDModeCustomView ;
    
    self.hud.customView = [[UIImageView alloc] initWithImage:image] ;
    
    self.hud.detailsLabel.text = status ;
    
    [self.hud showAnimated:YES] ;
    
    if (time > 0) {
        [self dismissAnimated:YES after:time] ;
    }
}

- (void)show:(NSString *)status dismissAfter:(NSTimeInterval)time
{
    // if hud alreay exist, remove it to create new one.
    if (_hud) [self p_removeHud] ;
    
    // if status is empty, don't show.
    if (status == nil || status.length < 1) {
        return ;
    }
    
    self.hud.mode = MBProgressHUDModeText ;
    
    self.hud.label.text = status ;
    
    [self.hud showAnimated:YES] ;
    
    if (time > 0) {
        [self dismissAnimated:YES after:time] ;
    }
}

- (void)showLoading:(NSString *)status
{
    if (_hud) [self p_removeHud] ;
    
    self.hud.mode = MBProgressHUDModeIndeterminate ;
    
    self.hud.detailsLabel.text = status ;
    
    [self.hud showAnimated:YES] ;
}

- (void)dismissAnimated:(BOOL)animated after:(NSTimeInterval)time
{
    if (_hud == nil) return ;
    
    if (time > 0) {
        [self.hud hideAnimated:animated afterDelay:time] ;
    }else{
        [self.hud hideAnimated:animated] ;
    }
}

- (void)p_removeHud
{
    // you have to invoke this not just removeFromSuperView, for cleaning the internal resources like timers in hud.
    [_hud hideAnimated:NO] ;
    
    [_hud removeFromSuperview] ;
    
    _hud = nil ;
}

#pragma mark - MBProgressHUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.hud removeFromSuperview] ;
    self.hud = nil ;
}


#pragma mark - lazy load

- (MBProgressHUD *)hud
{
    if (!_hud) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow] ;
        hud.removeFromSuperViewOnHide = YES ;
        [[UIApplication sharedApplication].keyWindow addSubview:hud] ;
        hud.delegate = self ;
        _hud = hud ;
    }
    return _hud ;
}

@end


@implementation ProgressHUD (DD_Deprecated)

+ (void)show:(NSString *)status Interaction:(BOOL)Interaction
{
    [self show:status] ;
}

+ (void)showSuccess:(NSString *)status Interaction:(BOOL)Interaction
{
    [self showSuccess:status] ;
}

+ (void)showError:(NSString *)status Interaction:(BOOL)Interaction
{
    [self showError:status] ;
}

@end

