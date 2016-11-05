//
//  NotificationView.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/4.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NotificationView.h"

@interface NotificationView ()

@property (nonatomic, strong) UILabel * label ;
@property (nonatomic, strong) UIImageView * closeView ;

@end

@implementation NotificationView

+ (instancetype) notificationView
{
    return [self new] ;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44) ;
    
    if (self = [super initWithFrame:frame]) {
        self.contentColor = [UIColor blackColor] ;
        self.contentBackgroundColor = [UIColor greenColor] ;
        

        [self addSubview:self.label] ;
        [self addSubview:self.closeView] ;
    
    }
    return self ;
}


#pragma mark - getter and setter

- (void)setContentColor:(UIColor *)contentColor
{
    _contentColor = contentColor ;
    
    self.label.textColor = contentColor ;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor
{
    _contentBackgroundColor = contentBackgroundColor ;
    
    self.backgroundColor = contentBackgroundColor ;
}

- (void)setContent:(NSString *)content
{
    _content = content ;
    
    
    //根据文字计算label的长度，做到一行显示所有的文字
    CGSize size = [content sizeOfFont:self.label.font maxWidth:MAXFLOAT maxHeight:self.dd_height] ;

    self.label.bounds = CGRectMake(0, 0, size.width + 8, self.dd_height
                                  ) ;
    
    
    self.label.text = content ;
    
    
    if (self.superview && self.content) {
        [self stopAnimations] ;
        [self scrollToShowWords] ;
    }
    
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds] ;
        _label.textColor = [UIColor whiteColor] ;
        _label.font = [UIFont systemFontOfSize:16] ;
        
    }
    return _label ;
}

- (UIImageView *)closeView
{
    if (!_closeView) {
        _closeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disclosure_indicator"]] ;
        _closeView.userInteractionEnabled = YES ;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)] ;
        [_closeView addGestureRecognizer:tap] ;
        
    }
    return _closeView ;
}


#pragma mark - Actions 

- (void)close:(UITapGestureRecognizer * )tapGesture
{
    
    [self removeFromSuperview] ;
}


// 滚动label
- (void)scrollToShowWords
{
    CGFloat duration = (self.label.dd_width + self.dd_width ) / self.label.font.pointSize * 0.2 ;
//    DDLog(@"%f",duration) ;
    [UIView animateWithDuration:duration delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.label.dd_left = - self.label.dd_width ;
    } completion:^(BOOL finished) {
        if (finished) {
            self.label.dd_left = self.dd_right ;
            [self scrollToShowWords] ;
        }
    }] ;
    
    
//    self.label.layer.anchorPoint = CGPointMake(0, 0) ;
//    self.label.layer.position = CGPointMake(0, 0) ;
//    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"] ;
//    animation.repeatCount = MAXFLOAT ;
//    animation.duration = duration ;
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.dd_right, 0)] ;
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake( - self.label.dd_width, 0)] ;
//    [self.label.layer addAnimation:animation forKey:nil] ;
//    
//    
}

// 停止动画
- (void)stopAnimations
{
    [self.label.layer removeAllAnimations] ;
    self.label.dd_left = 0 ;    //还原到原来的位置
}


#pragma mark - override system methods

- (void)didMoveToSuperview
{
    [super didMoveToSuperview] ;
    
    if (self.superview && self.content) {
        [self stopAnimations] ;
        [self scrollToShowWords] ;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    //删除的view
    CGFloat cw = self.closeView.dd_width ;
    CGFloat ch = self.closeView.dd_height ;
    CGFloat cx = self.dd_width - cw - 8 ;
    CGFloat cy = (self.dd_height - ch ) / 2 ;
    self.closeView.frame = CGRectMake( cx, cy, cw, ch) ;
}


- (void)dealloc
{
    DDLog(@"%s",__func__ );
}
@end
