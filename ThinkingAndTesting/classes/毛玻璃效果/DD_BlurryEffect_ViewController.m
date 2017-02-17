//
//  DD_BlurryEffect_ViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DD_BlurryEffect_ViewController.h"
#import "DDBlurryView.h"

@interface DD_BlurryEffect_ViewController ()
{
    DDBlurryView * _blurryView ;
}
@end

@implementation DD_BlurryEffect_ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor] ;
    self.navigationItem.title = @"毛玻璃效果" ;
    
    [self _dd_registerAllNotifications] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view addBlurEffect] ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view removeBlurEffect] ;
    });
}

- (void)_dd_registerAllNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dd_becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dd_resignActive:) name:UIApplicationWillResignActiveNotification object:nil] ;
}

- (void)_dd_becomeActive:(NSNotification *)note
{
    [UIView animateWithDuration:0.25 animations:^{
        _blurryView.alpha = 0 ;
        _blurryView.transform = CGAffineTransformMakeScale(1.1, 1.1) ;
    } completion:^(BOOL finished) {
        [_blurryView removeFromSuperview] ;
        _blurryView.alpha = 1 ;
        _blurryView.transform = CGAffineTransformIdentity ;
    }] ;
}

- (void)_dd_resignActive:(NSNotification *)note
{
    if (!_blurryView){
        _blurryView = [[DDBlurryView alloc] initWithFrame:self.view.bounds] ;
    }else{
        [_blurryView flashImageDueToScreenUpdate] ;
    }
    
    if (_blurryView.superview) return ;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blurryView] ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}
@end
