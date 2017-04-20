//
//  PasswordInputView.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/4/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "PasswordInputView.h"

@interface PasswordInputView ()
{
    UITextField * _textField ;

    UIButton    * _switchBtn ;
    
    NSString    * _previousText ;
}


@end

@implementation PasswordInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI] ;
    }
    return self ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)creatUI
{
    [self addSubview:self.textField] ;
    
    [self addSubview:self.switchBtn] ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    CGFloat marginLeft = 8 ;
    CGFloat marginRight = marginLeft ;
    
    /// 切换 按钮
    CGSize size = self.switchBtn.intrinsicContentSize ;
    CGFloat sW = size.width ;
    CGFloat sH = size.height ;
    CGFloat sX = self.dd_width - marginRight - sW ;
    CGFloat sY = (self.dd_height - sH) / 2 ;
    self.switchBtn.frame = CGRectMake(sX, sY, sW, sH) ;
    
    /// 输入框
    CGFloat x = marginLeft ;
    CGFloat y = 0 ;
    CGFloat h = self.dd_height ;
    CGFloat w = _switchBtn.dd_left - marginRight - x ;
    _textField.frame = CGRectMake(x,y,w,h) ;
}


#pragma mark - public api

- (void)setShowSecurityText:(BOOL)showSecurityText
{
    _showSecurityText = showSecurityText ;
    
    self.switchBtn.selected = showSecurityText ;
    
    self.textField.secureTextEntry = !showSecurityText ;
}

#pragma mark - Actions & Events

- (void)switchVisible
{
    self.showSecurityText = !_showSecurityText ;
}

- (void)textDidChange:(NSNotification *)note
{
    DDLog(@"%@",self.textField.text) ;
    if (self.maxInputLength)
    {
        if (self.textField.text && ![self.textField.text isEqualToString:_previousText])
        {
            if (self.textField.text.length > self.maxInputLength)
            {
                _textField.text = _previousText ;
            }
            else
            {
                _previousText = _textField.text ;
            }
        }
    }
}

#pragma mark - lazy load

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:self.bounds] ;
        _textField.secureTextEntry = YES ;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
        _textField.font = [UIFont systemFontOfSize:14] ;
        _textField.textColor = [UIColor blackColor] ;
        _textField.placeholder = @"请输入密码" ;
        
        /// 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:_textField] ;
    }
    return _textField ;
}

- (UIButton *)switchBtn
{
    if (!_switchBtn) {
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal] ;        /// 隐藏
        [_switchBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected] ;       /// 显示
        [_switchBtn addTarget:self action:@selector(switchVisible) forControlEvents:UIControlEventTouchDown] ;
    }
    return _switchBtn ;
}

@end
