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
    
    _textFieldBackgroundView.frame = CGRectMake(marginLeft, marginTop, self.dd_width - 2 * marginLeft, self.dd_height - 2 * marginTop) ;
    
    CGFloat offsetX  = self.cursorHorizontalOffset ;
    if (offsetX) {
        _textField.frame = CGRectMake(offsetX, 0, _textFieldBackgroundView.dd_width - offsetX , _textFieldBackgroundView.dd_height) ;
    }else{
        _textField.frame = _textFieldBackgroundView.bounds ;
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate searchBar:self shouldChangeCharactersInRange:range replacementString:string] ;
    }
    return YES ;
}

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
        
        _textField.leftViewMode = UITextFieldViewModeAlways ;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing ;
//        _textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor purpleColor] size:CGSizeMake(20, 20)]] ;
//        _textField.tintColor = [UIColor redColor] ;
    }
    return _textField ;
}
@end
