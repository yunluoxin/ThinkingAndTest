//
//  DD_BlurryEffect_ViewController2.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DD_BlurryEffect_ViewController2.h"

@interface DD_BlurryEffect_ViewController2 ()

@end

@implementation DD_BlurryEffect_ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor] ;
    self.navigationItem.title = @"毛玻璃效果2" ;
    
    [self _dd_registerAllNotifications] ;
}
- (void)_dd_registerAllNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dd_becomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dd_resignActive:) name:UIApplicationWillResignActiveNotification object:nil] ;
}

- (void)_dd_becomeActive:(NSNotification *)note
{
    [[UIApplication sharedApplication].keyWindow removeBlurEffectAnimated:YES] ;
}

- (void)_dd_resignActive:(NSNotification *)note
{   
    [[UIApplication sharedApplication].keyWindow addBlurEffect] ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
@end
