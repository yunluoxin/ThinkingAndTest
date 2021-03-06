//
//  CountDownAnnularView.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/30.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "CountDownAnnularView.h"

@interface CountDownAnnularView () <CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *annularBgLayer;     /**< 环的背景layer */
@property (nonatomic, strong) CAShapeLayer *annularFgLayer;     /**< 环的前景layer，会动的那个 */
@property (nonatomic, strong) UILabel *titleLabel;              /**< 环中间的文字label */
@end

@implementation CountDownAnnularView {
    BOOL _isWorking;    /**< 当前是否已经在工作中(倒计时中) */
    
    NSTimer *_timer;
    NSInteger _count;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultDatas];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupDefaultDatas];
        [self setupUI];
    }
    return self;
}

- (void)setupDefaultDatas {
    _annularWidth = 5.0;
    _annularBgColor = [[UIColor orangeColor] colorWithAlphaComponent:0.2];
    _progressColor = [UIColor orangeColor];
    _titleFont = [UIFont systemFontOfSize:13.0];
    _titleColor = [UIColor blackColor];
    _titleFormat = @"%d";
    _countDownFrom = 5;
}

- (void)setupUI {
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    CGFloat radius = (MIN(w, h) - self.annularWidth) / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    
    self.annularBgLayer = [CAShapeLayer layer];
    self.annularBgLayer.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    self.annularBgLayer.position = CGPointMake(midX, midY);
    self.annularBgLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.annularBgLayer.path = path.CGPath;
    self.annularBgLayer.lineWidth = self.annularWidth;
    self.annularBgLayer.strokeColor = self.annularBgColor.CGColor;
    self.annularBgLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.annularBgLayer];
    
    self.annularFgLayer = [CAShapeLayer layer];
    self.annularFgLayer.bounds = self.annularBgLayer.bounds;
    self.annularFgLayer.position = self.annularBgLayer.position;
    self.annularFgLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.annularFgLayer.path = path.CGPath;
    self.annularFgLayer.lineCap = kCALineCapRound;
    self.annularFgLayer.lineWidth = self.annularWidth;
    self.annularFgLayer.strokeColor = self.progressColor.CGColor;
    self.annularFgLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.annularFgLayer];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w/2, h/2)];
    self.titleLabel.center = self.annularFgLayer.position;
    self.titleLabel.font = self.titleFont;
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCountDownAnnularView:)];
    [self addGestureRecognizer:tap];
}


#pragma mark - Setter methods

- (void)setAnnularBgColor:(UIColor *)annularBgColor {
    _annularBgColor = annularBgColor;
    self.annularBgLayer.strokeColor = self.annularBgColor.CGColor;
}

- (void)setAnnularWidth:(CGFloat)annularWidth {
    _annularWidth = annularWidth;
    self.annularBgLayer.lineWidth = annularWidth;
    self.annularFgLayer.lineWidth = annularWidth;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.annularFgLayer.strokeColor = self.progressColor.CGColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleFormat:(NSString *)titleFormat {
    _titleFormat = titleFormat;
}

- (void)setCountDownFrom:(NSInteger)countDownFrom {
    _countDownFrom = countDownFrom;
}


#pragma mark - Public

- (void)start {
    if (_isWorking) return;
    
    _isWorking = YES;
    
    _count = self.countDownFrom;
    
    /* 启动时候回调一次 */
    if (self.countDown) {
        self.countDown(self.countDownFrom);
    }
    
    [self refreshUI];
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(1.0);
    animation.toValue = @(0);
    animation.duration = self.countDownFrom;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.annularFgLayer addAnimation:animation forKey:nil];
}

- (void)stop {
    _isWorking = NO;
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - Private

- (void)countDown:(id)userInfo {
    _count --;
    
    [self refreshUI];
    
    if (_count <= 0) {
        [self stop];
    }
    
    /* 每一秒都通知外部 */
    if (self.countDown) {
        self.countDown(_count);
    }
}

- (void)refreshUI {
    self.titleLabel.text = [NSString stringWithFormat:self.titleFormat, _count];
}


#pragma mark - Actions

- (void)didTapCountDownAnnularView:(id)sender {
    if (self.gestureTapCallBack) self.gestureTapCallBack(self);
}


#pragma mark - override

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self stop];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.annularFgLayer removeFromSuperlayer];
    }
}

@end
