//
//  DDTextView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/21.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDTextView.h"


@interface DDTextView ()

@property (nonatomic ,weak) UILabel *placeholderLabel ;

@end

@implementation DDTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];

        [self createUI];
        
        //监听文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    }
    return self ;
}

- (void)createUI
{
    UILabel *placeholderLabel = [[UILabel alloc]init];
    _placeholderLabel = placeholderLabel ;
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.font = self.font; ///默认的占位符字体大小和textView一样
    _placeholderLabel.numberOfLines = 0 ;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderLabel.enabled = NO ;
    [self addSubview:placeholderLabel];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder ;
    self.placeholderLabel.text = placeholder ;
}

- (void)setTextColorOfPlaceholder:(UIColor *)textColorOfPlaceholder
{
    _textColorOfPlaceholder = textColorOfPlaceholder ;
    self.placeholderLabel.textColor = textColorOfPlaceholder ;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = self.hasText ;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font ;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
}

//重写setText方法,防止直接通过textView.text赋值的，无法隐藏placeholder
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString*)attributedText {
    
    [super setAttributedText:attributedText];
    
    [self textDidChange]; //这里调用的就是UITextViewTextDidChangeNotification 通知的回调
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 5 ;
    CGFloat y = 8 ; //这两个值是一直尝试出来，差不多的
    CGSize size = [self.placeholder sizeOfFont:self.placeholderLabel.font maxWidth:self.dd_width - x * 2 maxHeight:self.dd_height - y * 2];
    self.placeholderLabel.frame = CGRectMake(x, y, size.width , size.height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self ];
}
@end
