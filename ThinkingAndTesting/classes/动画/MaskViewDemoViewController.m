//
//  MaskViewDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/29.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "MaskViewDemoViewController.h"

@interface MaskViewDemoViewController ()
@property (strong, nonatomic) UIView *testView;
@end

@implementation MaskViewDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    self.testView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.testView];
    self.testView.backgroundColor = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 300, 500)];
//    [rectPath setUsesEvenOddFillRule:YES];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 140, 100, 100) cornerRadius:50];

    //    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 500) radius:50 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //    [rectPath appendPath:roundPath];
    [rectPath appendPath:path];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.view.bounds;
    [self.testView.layer addSublayer:layer];
    
    layer.path = rectPath.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;    ///< 设置使用奇偶规则。 则path中偶数次叠加的区域，不会被填充，奇数次的区域，会被填充！
    layer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
}

@end
