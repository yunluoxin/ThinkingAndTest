//
//  DDBaseViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface DDBaseViewController ()
{
    NSInteger _previousBarStyle ;
    NSInteger _previousNavigationBarStatus ;
}
@end

@implementation DDBaseViewController

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]) {
        [self p_base_setupDatas] ;
    }
    return self ;
}

- (void)p_base_setupDatas
{
    _previousBarStyle = -1 ;
    _previousNavigationBarStatus = -1 ;
}

- (void)dealloc
{
    NSLog(@"%s",__func__) ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"DDBaseViewController" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if (self.handleKeyboardEvent) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil] ;
    }
    
    if (_previousBarStyle != -1) {
        [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle ;
    }
    
    if (_previousNavigationBarStatus != -1) {
        self.navigationController.navigationBarHidden = self.navigationBarHidden ;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    if (self.handleKeyboardEvent) {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil] ;
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil] ;
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil] ;
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil] ;
    }
    
    /// restore
    if (_previousBarStyle != -1) {
        [UIApplication sharedApplication].statusBarStyle = _previousBarStyle ;
    }
    
    if (_previousNavigationBarStatus != -1) {
        self.navigationController.navigationBarHidden = _previousNavigationBarStatus ;
    }
}

#pragma mark - actions

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle ;
    
    /// store
    _previousBarStyle = [UIApplication sharedApplication].statusBarStyle ;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    _navigationBarHidden = navigationBarHidden ;
    
    /// store
    _previousNavigationBarStatus = self.navigationController.isNavigationBarHidden ;
}

- (BOOL)isStatusBarVisible
{
    return ![UIApplication sharedApplication].isStatusBarHidden ;
}

- (void)hideStatusBarAnimated:(BOOL)animated
{
    if (self.isStatusBarVisible == NO) return ;
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [UIApplication sharedApplication].statusBarHidden = YES ;
        }] ;
    }else{
        [UIApplication sharedApplication].statusBarHidden = YES ;
    }
}

- (void)showStatusBarAnimated:(BOOL)animated
{
    if (self.isStatusBarVisible) return ;
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [UIApplication sharedApplication].statusBarHidden = NO ;
        }] ;
    }else{
        [UIApplication sharedApplication].statusBarHidden = NO ;
    }
}

- (BOOL)isNavigationBarVisible
{
    return self.navigationController && !self.navigationController.isNavigationBarHidden ;
}

- (void)hideNavigationBarAnimated:(BOOL)animated
{
    if (self.isNavigationBarVisible == NO) return ;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated] ;
}

- (void)showNavigationBarAnimated:(BOOL)animated
{
    if (self.isNavigationBarVisible) return ;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated] ;
}

- (void)showNavigationBarBottomLine
{
    if (!self.navigationController) return ;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]] ;
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.navigationController.navigationBar.dd_width, 0.5)] ;
    lineView.backgroundColor = [UIColor lightGrayColor] ;
    lineView.alpha = 0.2 ;
    lineView.tag = 66 ;
    [self.navigationController.navigationBar addSubview:lineView] ;
}

- (BOOL)isModal
{
    return self.presentingViewController ;
}

- (void)onKeyboardWillShow:(NSNotification *)notification
{
    _keyboardFrame_relatedToScreen = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] ;
}

- (void)onKeyboardDidShow:(NSNotification *)notification
{
    _keyboardFrame_relatedToScreen = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] ;
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    _keyboardFrame_relatedToScreen = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] ;
}

- (void)onKeyboardDidHide:(NSNotification *)notification
{
    _keyboardFrame_relatedToScreen = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] ;
}


#pragma mark - private methods


@end


@implementation UIViewController (XDProgressHUD)

#pragma mark - ProgressHUD
- (XDProgressHUD *)showLoadingWithText:(NSString *)text
{
    XDProgressHUD * hud = [XDProgressHUD showHUDAddedTo:self.view animated:YES] ;
    hud.mode = MBProgressHUDModeIndeterminate ;
    hud.label.text = text ;
    return hud ;
}

- (XDProgressHUD *)showText:(NSString *)text
{
    XDProgressHUD * hud = [XDProgressHUD showHUDAddedTo:self.view animated:YES] ;
    hud.mode = MBProgressHUDModeText ;
    hud.label.text = text ;
    return hud ;
}

- (XDProgressHUD *)showSuccessWithText:(NSString *)text
{
    XDProgressHUD * hud = [XDProgressHUD showHUDAddedTo:self.view animated:YES] ;
    hud.mode = MBProgressHUDModeCustomView ;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] ;
    hud.detailsLabel.text = text ;
    return hud ;
}

- (XDProgressHUD *)showErrorWithText:(NSString *)text
{
    XDProgressHUD * hud = [XDProgressHUD showHUDAddedTo:self.view animated:YES] ;
    hud.mode = MBProgressHUDModeCustomView ;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] ;
    hud.detailsLabel.text = text ;
    return hud ;
}

- (void)dismissAllHuds
{
    bool end = NO ;
    while (!end) {
        end = ![XDProgressHUD hideHUDForView:self.view animated:YES] ;
    }
}

- (void)dismissAllHudsAfter:(NSTimeInterval)seconds
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAllHuds] ;
    });
}

@end
