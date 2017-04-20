//
//  DDSearchBar.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/23.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDSearchBar.h"

@interface DDSearchBar ()<UITextFieldDelegate>
{
    UIView * _textFieldBackgroundView ;
    
    /**
     *  取消按钮
     */
    UIButton * _cancelButton ;
}

@property (nonatomic, strong)UITextField * textField ;

@end

@implementation DDSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI] ;
    }
    return self ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)setupUI
{
    self.backgroundColor = HexColor(0xbfc9c4) ;
    
    _textFieldBackgroundView = [UIView new] ;
    _textFieldBackgroundView.backgroundColor = [UIColor whiteColor] ;
    _textFieldBackgroundView.layer.cornerRadius = 5 ;
    [_textFieldBackgroundView addSubview:self.textField] ;
    
    [self addSubview:_textFieldBackgroundView] ;
}


#pragma mark - layout

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    CGFloat marginLeft = 8 ;
    CGFloat marginTop  = 8 ;
    
    
    if (!_showCancelButton)
        /// 不显示取消按钮
    {
        _textFieldBackgroundView.frame = CGRectMake(marginLeft, marginTop, self.dd_width - 2 * marginLeft, self.dd_height - 2 * marginTop) ;
    }
    else
        /// 显示取消按钮
    {
        /// 取消按钮
        CGSize cSize = [_cancelButton intrinsicContentSize] ;
        CGFloat cX   = _cancelButton.superview.dd_width - cSize.width - marginLeft ;
        CGFloat cY   = 0 ;
        _cancelButton.frame = CGRectMake(cX, cY, cSize.width, _cancelButton.superview.dd_height) ;
        

        CGFloat x = marginLeft ;
        CGFloat y = marginTop ;
        CGFloat w = _cancelButton.dd_left - x - marginLeft ;
        CGFloat h = self.dd_height - 2 * marginTop ;
        _textFieldBackgroundView.frame = CGRectMake(x,y,w,h) ;
        
    }
    
    
    
    CGFloat offsetX  = self.cursorHorizontalOffset ;
    _textField.frame = CGRectMake(offsetX, 0, _textFieldBackgroundView.dd_width - offsetX , _textFieldBackgroundView.dd_height) ;
}


#pragma mark - API

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder ;
    
    self.textField.placeholder = placeholder ;
}

- (void)setPlaceholderAttributedText:(NSAttributedString *)placeholderAttributedText
{
    _placeholderAttributedText = placeholderAttributedText ;
    
    self.textField.attributedPlaceholder = placeholderAttributedText ;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor ;
    
    UILabel * placeholder = [_textField valueForKey:@"_placeholderLabel"] ;
    placeholder.textColor = placeholderTextColor ;
    
}

- (void)setPlaceholderTextFont:(UIFont *)placeholderTextFont
{
    _placeholderTextFont = placeholderTextFont ;
    
    UILabel * placeholder = [_textField valueForKey:@"_placeholderLabel"] ;
    placeholder.font = placeholderTextFont ;
}

- (void)setText:(NSString *)text
{
    _text = text ;
    
    self.textField.text = text ;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText ;
    
    self.textField.attributedText = attributedText ;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor ;
    
    self.textField.textColor = textColor ;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont ;
    
    self.textField.font = textFont ;
}

- (void)setShowCancelButton:(BOOL)showCancelButton
{
    if (_showCancelButton == showCancelButton) return ;
    
    _showCancelButton = showCancelButton ;
    
    if (showCancelButton)
    {
        [self addSubview:self.cancelButton] ;
        [UIView animateWithDuration:0.25 animations:^{
            _cancelButton.transform = CGAffineTransformIdentity ;
        }] ;
    }
    else
    {
        if (_cancelButton)
        {
            [UIView animateWithDuration:0.25 animations:^{
                _cancelButton.transform = CGAffineTransformMakeScale(0.1, 0.1) ;
            } completion:^(BOOL finished) {
                [_cancelButton removeFromSuperview] ;
                //            _cancelButton = nil ;
            }] ;
        }
    }
 
    if (self.window)
    {
//        [self setNeedsLayout] ;
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded] ;
        }] ;
    }
}


- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor ;
    
    _textFieldBackgroundView.backgroundColor = barTintColor ;
}

- (void)setSearchBarLeftImage:(UIImage *)searchBarLeftImage
{
    _searchBarLeftImage = searchBarLeftImage ;
    
    self.textField.leftView = [[UIImageView alloc] initWithImage:searchBarLeftImage highlightedImage:searchBarLeftImage] ;
}

- (void)setTextFieldCornerRadius:(CGFloat)textFieldCornerRadius
{
    _textFieldCornerRadius = textFieldCornerRadius ;
    
    _textFieldBackgroundView.layer.cornerRadius = textFieldCornerRadius ;
}

- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor ;
    
    self.textField.tintColor = cursorColor ;
}


#pragma mark - UITextFieldDelegate 协议转发

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [self.delegate searchBarShouldBeginEditing:self] ;
    }
    return YES ;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]) {
        [self.delegate searchBarDidBeginEditing:self] ;
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self] ;
    }
    return YES ;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
        return [self.delegate searchBarDidEndEditing:self] ;
    }
}

///
/// @attention 按清除按钮清空文字时候，这个不会被执行
///
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate searchBar:self shouldChangeCharactersInRange:range replacementString:string] ;
    }
    return YES ;
}

/// 执行这个方法时候，还没有将textField清空。只有返回yes之后才回进行清空， 所以在方法里面能获取到原来的文字
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldClear:)]) {
        return [self.delegate searchBarShouldClear:self] ;
    }
    
    return YES ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldReturn:)]) {
        return [self.delegate searchBarShouldReturn:self] ;
    }
    
    return NO ;
}


#pragma mark - Actions & Events

- (void)pressedCancelButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self] ;
    }
}

- (void)textDidChange:(NSNotification *)note
{
    if (_delegate && [_delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [_delegate searchBar:self textDidChange:self.textField.text] ;
    }
}


#pragma mark - getter and setter

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:_textFieldBackgroundView.bounds] ;
        _textField.placeholder = self.placeholder ;
        _textField.delegate = self ;
        _textField.borderStyle = UITextBorderStyleNone ;
        _textField.backgroundColor = [UIColor clearColor] ;
        _textField.placeholder = @"搜索" ;
        _textField.font = [UIFont systemFontOfSize:15] ;
        _textField.textAlignment = NSTextAlignmentLeft ;
        _textField.returnKeyType = UIReturnKeySearch ;
        _textField.enablesReturnKeyAutomatically = NO ; // 设置成: 输入是空时候也可以搜索
        
        _textField.leftViewMode = UITextFieldViewModeAlways ;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
//        _textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)]] ;
//        _textField.tintColor = [UIColor redColor] ;
        
        /// 监听文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:_textField] ;
    }
    return _textField ;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.dd_width, 0, 0, self.dd_height)] ;
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal] ;
        [_cancelButton setTitleColor:self.tintColor forState:UIControlStateNormal] ;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14] ;
        _cancelButton.backgroundColor = [UIColor clearColor] ;
        _cancelButton.transform = CGAffineTransformMakeScale(0.1, 0.1) ;
        [_cancelButton addTarget:self action:@selector(pressedCancelButton:) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _cancelButton ;
}
@end
