//
//  DDNavigationBar.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDNavigationBar.h"

#ifndef KNavBarHeight
#define kNavBarHeight 44.0
#endif

@interface DDNavigationBar ()

@property (nonatomic, strong) UIView * bottomLine ;
@property (nonatomic, strong) UIImageView * backgroundImageView ;
@property (strong, nonatomic) UIVisualEffectView * translucentView ;

@property (strong, nonatomic) UIView * titleView ;

@end

@implementation DDNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height = kNavBarHeight ;
    if (self = [super initWithFrame:frame]) {
        [self setupDatas] ;
        [self createView];
    }
    return self ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDatas] ;
        [self createView];
    }
    return self ;
}

- (void)setupDatas
{
    _barTintColor = [UIColor whiteColor] ;
    _titleColor   = [UIColor blackColor] ;
    _titleFont    = [UIFont systemFontOfSize:16] ;
}

- (void)createView
{
    [self addSubview:self.backgroundImageView] ;
    
    [self.backgroundImageView addSubview:self.bottomLine] ;
    
    self.translucent = YES ;
}

#pragma mark - setter and setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage ;
    
    self.backgroundImageView.image = backgroundImage ;
    
    self.barTintColor = [UIColor clearColor] ;
}

- (void)setTranslucent:(BOOL)translucent
{
    _translucent = translucent ;
    
    if (translucent) {
        [self.backgroundImageView insertSubview:self.translucentView atIndex:0] ;
        self.barTintColor = [self.barTintColor colorWithAlphaComponent:.75] ;
    }else{
        self.barTintColor = [self.barTintColor colorWithAlphaComponent:1] ;
        if (_translucentView){
            [_translucentView removeFromSuperview] ;
            _translucentView = nil ;
        }
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor ;
    
    self.backgroundColor = barTintColor ;
}

- (void)setNavigationItem:(UINavigationItem *)navigationItem
{
    _navigationItem = navigationItem ;
    
    [self.titleView removeFromSuperview] ;
    self.titleView = nil ;
    
    CGRect frame = CGRectZero ;
    
    if (navigationItem.titleView)
    {
        self.titleView = navigationItem.titleView ;
    }
    else
    if (navigationItem.title)
    {
        CGRect rect = [navigationItem.title boundingRectWithSize:CGSizeMake(self.dd_width, kNavBarHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                                     NSForegroundColorAttributeName:self.titleColor,
                                                     NSFontAttributeName:self.titleFont
                                                     }
                                           context:NULL] ;
        frame.size = rect.size ;
        UILabel * label = [[UILabel alloc] initWithFrame:frame] ;
        label.textColor = self.titleColor ;
        label.textAlignment = NSTextAlignmentCenter ;
        label.font = self.titleFont;
        label.text = navigationItem.title ;
        label.backgroundColor = [UIColor clearColor] ;
        self.titleView = label ;
    }
    
    if (self.titleView)
    {
        [self addSubview:self.titleView] ;
        CGFloat maxWidth = self.dd_width * 4.0/5 ;  /// 设置中间标题最大宽度为4/5
        if (self.titleView.dd_width > maxWidth) self.titleView.dd_width = maxWidth ;
        CGFloat x = (self.dd_width -  self.titleView.dd_width ) / 2 ;
        CGFloat y = 0 ;
        self.titleView.frame = CGRectMake(x, y, self.titleView.dd_width, self.dd_height) ;
    }
}


- (UIVisualEffectView *)translucentView
{
    if (!_translucentView) {
        UIVisualEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight] ;
        _translucentView = [[UIVisualEffectView alloc] initWithEffect:effect] ;
    }
    return _translucentView ;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init] ;
        _bottomLine.backgroundColor = HexColor(0xFFE7E7E7) ;
    }
    return _bottomLine ;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds] ;
    }
    return _backgroundImageView ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    CGRect frame = self.bounds ;
    frame.origin.y = - 20 ;
    frame.size.height = kNavBarHeight + 20 ;
    self.backgroundImageView.frame = frame ;
    
    if (_bottomLine)
    {
        CGFloat h = 1 / IOS_SCALE ;
        _bottomLine.frame = CGRectMake(0, _bottomLine.superview.dd_height - h, _bottomLine.superview.dd_width, h) ;
    }
}
@end
