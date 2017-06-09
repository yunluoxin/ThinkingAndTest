//
//  PageIndicatorEllipseView.m
//  kachemama
//
//  Created by dadong on 2017/5/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "PageIndicatorEllipseView.h"

#define PageIndicatorEllipseViewTextFontSize 10.f   // 字体大小
#define PageIndicatorEllipseViewWidth 80.f          // 整个view宽度
#define PageIndicatorEllipseViewHeigth 15.f         // 整个view高度
#define PageIndicatorEllipseViewCornerRadius 8.f    // 弧边半径

@interface PageIndicatorEllipseView ()
/**
 *  遮罩层
 */
@property (strong, nonatomic)UIView * maskView ;
/**
 *  计数的真正Label
 */
@property (strong, nonatomic)UILabel * countLabel ;

@end

@implementation PageIndicatorEllipseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews] ;
    }
    return self ;
}

+ (instancetype)pageIndicatorEllipseView
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, PageIndicatorEllipseViewWidth, PageIndicatorEllipseViewHeigth)] ;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor] ;
    
    // 遮罩
    [self addSubview:self.maskView] ;
    
    // 计数
    [self.maskView addSubview:self.countLabel] ;
}

- (void)setCurrentNum:(NSUInteger)currentNum
{
    _currentNum = currentNum ;
    
    [self configureLabel] ;
}

- (void)setTotalNum:(NSUInteger)totalNum
{
    _totalNum = totalNum ;
    
    [self configureLabel] ;
}


- (void)configureLabel
{
    NSString * content = [NSString stringWithFormat:@"%ld/%ld",_currentNum, _totalNum] ;
    self.countLabel.text = content ;
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    self.maskView.center = CGPointMake(self.dd_width/2, self.dd_height/2) ;
    self.countLabel.frame = self.maskView.bounds ;
}

#pragma mark - getter

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:self.maskView.bounds] ;
        _countLabel.textColor = [UIColor whiteColor] ;
        _countLabel.textAlignment = NSTextAlignmentCenter ;
        _countLabel.font = [UIFont systemFontOfSize:PageIndicatorEllipseViewTextFontSize] ;
        _countLabel.backgroundColor = [UIColor clearColor] ;
    }
    return _countLabel ;
}


- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds] ;
        _maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3] ;
        _maskView.layer.cornerRadius = PageIndicatorEllipseViewCornerRadius ;
        _maskView.layer.masksToBounds = YES ;
    }
    return _maskView ;
}

@end
