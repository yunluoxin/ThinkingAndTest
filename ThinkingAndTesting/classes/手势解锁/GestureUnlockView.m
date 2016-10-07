//
//  GestureUnlockView.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "GestureUnlockView.h"
#import "UIImage+Compress.h"

@interface GestureUnlockView ()

@property (nonatomic, assign)CGPoint currentPoint ;
@property (nonatomic, strong)NSMutableArray *selectedBtns ;

@property (nonatomic, assign)BOOL wrong ;
@end

@implementation GestureUnlockView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _rowNumber = 3 ;
        _colNumber = 3 ;
        _lineColor = [UIColor greenColor] ;
        _lineColorWhenWrong = [UIColor redColor] ;
        _spacing = 20.0f ;
        UIImage *image = [UIImage scaleImage:[UIImage imageNamed:@"ali.jpg"] toScale:0.1];
        UIImage *normalImage = [self imageWithBigCircleRadius:image.size.width/2 andSmallCircleRadius:image.size.width/2 - 10] ;
        _normalImage = normalImage ;
        _selectedImage = image ;
        
        self.backgroundColor = [UIColor blackColor] ;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)] ;
        [self addGestureRecognizer:pan ] ;
        
        for (int i = 0 ; i < _rowNumber * _colNumber; i ++ ) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            [self addSubview:btn] ;
            btn.tag = i ;
            [btn setImage:_selectedImage forState:UIControlStateSelected ] ;
            [btn setImage:_normalImage  forState: UIControlStateNormal ] ;
            btn.userInteractionEnabled = NO ;
        }
        
    }
    return self ;
}

- (void)setColNumber:(NSInteger)colNumber
{
    _colNumber = colNumber ;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    for (int i = 0 ; i < _rowNumber * _colNumber; i ++ ) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [self addSubview:btn] ;
        btn.tag = i ;
        [btn setImage:_selectedImage forState:UIControlStateSelected ] ;
        [btn setImage:_normalImage  forState: UIControlStateNormal ] ;
        btn.userInteractionEnabled = NO ;
    }
}


- (void)setRowNumber:(NSInteger)rowNumber
{
    _rowNumber = rowNumber ;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
    
    for (int i = 0 ; i < _rowNumber * _colNumber; i ++ ) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [self addSubview:btn] ;
        btn.tag = i ;
        [btn setImage:_selectedImage forState:UIControlStateSelected ] ;
        [btn setImage:_normalImage  forState: UIControlStateNormal ] ;
        btn.userInteractionEnabled = NO ;
    }
}
- (void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage ;
    for (int i = 0 ; i < self.subviews.count; i ++ ) {
        UIButton *btn = self.subviews[i ];
        [btn setImage:normalImage  forState: UIControlStateNormal ] ;
    }
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage ;
    for (int i = 0 ; i < self.subviews.count; i ++ ) {
        UIButton *btn = self.subviews[i ];
        [btn setImage:selectedImage forState:UIControlStateSelected ] ;
    }
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self] ;
    for (int i = 0 ; i < self.subviews.count; i ++) {
        UIButton *btn = self.subviews[i];
        if (CGRectContainsPoint(btn.frame, point) && btn.isSelected == NO) {
            btn.selected = YES ;
            [self.selectedBtns addObject:btn] ;
            break ;
        }
    }
    self.currentPoint = point ;
    [self setNeedsDisplay ] ;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        NSMutableString *strM = [NSMutableString string] ;
        for (int i = 0 ; i < self.selectedBtns.count; i ++) {
            UIView *view = self.selectedBtns[i ];
            [strM appendFormat:@"%ld",view.tag ] ;
        }
//        NSLog(@"%@",strM) ;
        
        //验证对错
        if (_delegate && [_delegate respondsToSelector:@selector(gestureUnlockView:isRightWithReceivedInput:)]) {
            self.wrong = ![_delegate gestureUnlockView:self isRightWithReceivedInput:[strM copy]] ;
        }
        [self setNeedsDisplay] ;
        
        //正确立马销毁
        if (self.wrong == NO) {
            [self destroy] ;
            return ;
        }
        
        //错误就显示错误几秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self destroy] ;
        });
    }
}

- (void)destroy
{
    [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:(id)NO] ;
    [self.selectedBtns removeAllObjects] ;
    self.wrong = NO ;
    [self setNeedsDisplay] ;
}

- (void)drawRect:(CGRect)rect
{
    if (self.selectedBtns.count == 0) {
        return ;
    }
    UIBezierPath *path = [UIBezierPath bezierPath] ;
    for (int i = 0;  i < self.selectedBtns.count; i ++) {
        UIView *view = self.selectedBtns[i ];
        if (i == 0) {
            [path moveToPoint:view.center] ;
        }else{
            [path addLineToPoint:view.center] ;
        }
    }
    [path addLineToPoint:_currentPoint] ;
    
    if (self.wrong) {
        [self.lineColorWhenWrong setStroke] ;
    }else{
        [self.lineColor setStroke] ;
    }
    path.lineWidth = 3 ;
    [path stroke] ;
}
- (NSMutableArray *)selectedBtns
{
    if (!_selectedBtns) {
        _selectedBtns = [NSMutableArray array] ;
    }
    return _selectedBtns ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    CGFloat tw = self.frame.size.width ;
    CGFloat th = self.frame.size.height ;
    CGFloat t = MIN(tw, th) ;
    
    CGFloat spacing = self.spacing ;

    CGFloat w = (t - spacing *(self.colNumber + 1)) / self.colNumber ;
    CGFloat h = (t - spacing *(self.rowNumber + 1)) / self.rowNumber  ;
    for (int i = 0 ; i < self.subviews.count; i ++) {
        NSInteger row = i / self.colNumber ;
        NSInteger col = i % self.colNumber ;
        CGFloat x = spacing + (w + spacing) * col ;
        CGFloat y = spacing + (h + spacing) * row ;
        UIView *view = self.subviews[i];
        view.frame = CGRectMake(x, y, w, h) ;
    }
}

- (UIImage *)imageWithBigCircleRadius:(CGFloat)bigRadius andSmallCircleRadius:(CGFloat)smallRadius
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(bigRadius * 2 + 2 , bigRadius * 2 + 2), NO, 0) ;
    CGPoint center = CGPointMake(bigRadius + 1 , bigRadius + 1) ;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:bigRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES ];
    [[UIColor greenColor] setStroke] ;
    path.lineWidth = 2 ;
    [path stroke] ;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:smallRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES ];
    [[UIColor yellowColor] setStroke] ;
    path2.lineWidth = 2 ;
    [path2 stroke] ;
    
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:center radius:10 startAngle:0 endAngle:M_PI * 2 clockwise:YES ];
    [[UIColor redColor] setFill] ;
    [path3 fill] ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}
@end
