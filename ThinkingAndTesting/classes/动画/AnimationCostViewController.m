
//
//  AnimationCostViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/25.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "AnimationCostViewController.h"

@interface AnimationCostViewController ()
@property (strong, nonatomic) UIView *testView;
@property (strong, nonatomic) UIView *blurView;
@end

@implementation AnimationCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.testView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TIK(1);
    TIK(0);
    [self addBlurEffect];
    [UIView animateWithDuration:0.25 animations:^{
        self.blurView.alpha = 1.0;
        self.blurView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        TOCK(0);
        [UIView animateWithDuration:0.25 animations:^{
            self.blurView.frame = CGRectMake(self.view.dd_width / 4, self.view.dd_height / 4, self.view.dd_width / 2, self.view.dd_height / 2);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    asyn_main(^{
        [self simulateBigCostWork:0.25];
        TOCK(1);
    });
}

- (void)test {
    TIK(1);
    TIK(0);
    [UIView animateWithDuration:1.2 animations:^{
        self.testView.alpha = 1.0;
    } completion:^(BOOL finished) {
        TOCK(0);
        [UIView animateWithDuration:2 animations:^{
            self.testView.alpha = 0.0;
        }];
    }];
    
    asyn_main(^{
        [self simulateBigCostWork:2];
        TOCK(1);
    });
}

- (void)simulateBigCostWork:(double)timeInterval {
    DDLog(@"enter sleep...");
    [NSThread sleepForTimeInterval:timeInterval];
    DDLog(@"awake from sleep...");
}

- (UIView *)testView {
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:self.view.bounds];
        _testView.backgroundColor = [UIColor purpleColor];
        _testView.alpha = 0.0;
    }
    return _testView;
}

- (UIView *)blurView {
    if (!_blurView) {
        _blurView = [[UIView alloc] initWithFrame:CGRectMake(self.view.dd_width / 4, self.view.dd_height / 4, self.view.dd_width / 2, self.view.dd_height / 2)];
        _blurView.backgroundColor = [UIColor purpleColor];
        _blurView.alpha = 0.0;
        [self.view addSubview:_blurView];
    }
    return _blurView;
}

- (void)addBlurEffect {

}

@end
