//
//  CALayerDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/26.
//  Copyright © 2018 dadong. All rights reserved.
//
//  动画之后，虽然显示的不在本地了，但是点击原来那个区域，还是能响应！打印出来的frame区域还是原位置的！
//  我估计：hitTest时候，视图层级不变，而区域又不变，还是会和原来一样被选中。 至于当前屏幕上显示的不在原位置，可能和layer里面还有多个什么renderTree, presentTree， 动画树有关
//  对UIView的frame进行变化。如果变的是宽高，会影响到不在原位置的显示的。但是如果变动是origin,只会影响到在原位置的，不会影响到显示的！相应的，想点击，也要换位置了！
//
//  经过对presentLayer, modelLayer的demo， 可能是做动画的是presentLayer, 返回的是只读，他是一直变换的，某一个时刻的显示所代表的layer，打印它的layer，确实是最新
//  的位置的！ 而modelLayer经过返回的就是layer本身(不知道怎么搞其他的), 对他进行变化，界面上点击响应的位置，真的改变了！ 所以，其实之所以改变UIView的frame，可以改变
//  点击位置，UIView是主Layer的代理，改了它就是改了主Layer,也是此时的modelLayer.
//
#import "CALayerDemoViewController.h"

@interface CALayerDemoViewController ()
@property (strong, nonatomic) UIView *maskView;
@end

@implementation CALayerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    
    [self.view addSubview:self.maskView];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)basicMove {
    CABasicAnimation *moveAnimation = [CABasicAnimation animation];
    moveAnimation.keyPath = @"position";
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 400)];
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    [self.maskView.layer addAnimation:moveAnimation forKey:nil];
}

- (void)advancedMove {
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animation];
//    moveAnimation.keyPath = @"transform.scale";
//    moveAnimation.values = @[
//                             @(0.5),@(0.3),@(0.2),@(0.5),@(1)
//                             ];
    moveAnimation.keyPath = @"transform.translation.y";
    moveAnimation.values = @[
                             @(120),@(180),@(300),@(150),@(200)
                             ];

    moveAnimation.duration = 2;
    moveAnimation.removedOnCompletion = NO;
//    moveAnimation.autoreverses = YES;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; ///< 淡入淡出，有点逐渐加快速度，后面又慢慢停下的感觉
    [self.maskView.layer addAnimation:moveAnimation forKey:nil];
}

- (void)moveAtPath {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddEllipseInRect(pathRef, NULL, CGRectMake(100, 100, 200, 200));
    animation.path = pathRef;
    animation.keyPath = @"position";
    CGPathRelease(pathRef);
    animation.duration = 2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;         ///< 这个必须是NO， 下面的 kCAFillModeForwards 才能生效，不然还是返回原点！
    animation.fillMode = kCAFillModeForwards;
    [self.maskView.layer addAnimation:animation forKey:nil];
}

/// 过渡动画
- (void)transition {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal; ///< 揭开 （拉开窗帘的效果）
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 2;
    self.maskView.backgroundColor = [UIColor purpleColor];
    [self.maskView.layer addAnimation:transition forKey:nil];
}

/// 事务
- (void)transaction {
    [CATransaction begin];
    [CATransaction setAnimationDuration:.25];
//    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

    self.maskView.layer.sublayers[0].position = CGPointMake(100, 200);
    
    [CATransaction commit];
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveAtPath];

    delay_main(1, ^{
        NSLog(@"layer: %@", self.maskView.layer);
        CALayer *presentLayer = [self.maskView.layer presentationLayer];
        NSLog(@"presentLayer: %@, frame: %@", presentLayer, NSStringFromCGRect(presentLayer.frame)); ///< 每次一直变换！新对象！
        CALayer *modelLayer = [presentLayer modelLayer];
        NSLog(@"modelLayer: %@", modelLayer);
        NSLog(@"modelLayer2: %@", [self.maskView.layer modelLayer]);

        DDLog(@"%@", NSStringFromCGRect(modelLayer.frame));
        modelLayer.frame = CGRectMake(0, 0, 100, 100);
        DDLog(@"%@", NSStringFromCGRect(modelLayer.frame));
    });
}

- (void)test:(id)sender {
    DDLog(@"%@", sender);
    self.maskView.dd_top += 105;
}

#pragma mark - Lazy load

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _maskView.backgroundColor = [UIColor greenColor];
        _maskView.center = self.view.center;
        DDLog(@"%@", NSStringFromCGRect(self.maskView.frame));
        UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
        _maskView.userInteractionEnabled = YES;
        [_maskView addGestureRecognizer:ges];
        CALayer *layer = [CALayer layer];
        layer.frame = self.maskView.layer.bounds;
        layer.backgroundColor = [UIColor cyanColor].CGColor;
        [self.maskView.layer addSublayer:layer];
        
    }
    return _maskView;
}

@end
