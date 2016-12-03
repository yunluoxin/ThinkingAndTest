//
//  ADViewController.m
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ADViewController.h"
#import "UIImageView+WebCache.h"
#import "ADManager.h"
#import "ADModel.h"
#import "DDTaskManager.h"
@interface ADViewController ()
{
    NSTimer *_timer ;
}

/**
    背景图片view
 */
@property (nonatomic, strong) UIImageView * backgroundImageView ;
//立即跳过 按钮
@property (nonatomic, strong) UIButton * stepBtn ;
//计数的label
@property (nonatomic, strong) UILabel * countLabel ;
@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundImageView] ;
    
    [self.view addSubview:self.stepBtn] ;
    
    [self.view addSubview:self.countLabel] ;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES] ;
    
}

- (void)dealloc
{
    DDLog(@"广告VC被销毁") ;
}


#pragma mark - Actions

static int count = 3 ;      //倒计时3s

- (void)countTime
{
    count -- ;
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",count] ;
    
    if (count <= 0) {
        [self step:nil] ;
    }
    
}

- (void)step:(id)sender
{
    [_timer invalidate] ;
    _timer = nil ;
    count = 3 ;
    
//    [self removeFromParentViewController] ;
    [self.view removeFromSuperview] ;
}

- (void)tapAD:(UITapGestureRecognizer *)tap
{
    [[UIApplication sharedApplication].keyWindow.rootViewController showLogin] ;
    
//    [UrlRounter openUrl:@"kachemama://detail?goodsSn=221200GG112"] ;
//    [UrlRounter openUrl: [ADModel defaultInstance].ad.page] ;
    
    DDTask *task = [DDTask new] ;
    task.pageUrl = @"kachemama://detail?goodsSn=221200GG112" ;
    task.type = DDTaskNewPageType ;
    [DDTaskManager addTask:task] ;
    
    [self step:nil] ;
}


#pragma mark - setter and getter

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds] ;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill ;
        _backgroundImageView.userInteractionEnabled = YES ;
        _backgroundImageView.backgroundColor = [UIColor yellowColor] ;
        [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[ADModel defaultInstance].ad.adImage] completed:nil] ;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAD:)] ;
        [_backgroundImageView addGestureRecognizer:tap] ;
    }
    return _backgroundImageView ;
}

- (UIButton *)stepBtn
{
    if (!_stepBtn) {
        _stepBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _stepBtn.frame = CGRectMake(0, 300, 100, 50) ;
        [_stepBtn setTitle:@"跳过" forState:UIControlStateNormal] ;
        [_stepBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal] ;
        [_stepBtn addTarget:self action:@selector(step:) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _stepBtn ;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 50 , 100 , 25, 25)] ;
        _countLabel.textAlignment = NSTextAlignmentCenter ;
        _countLabel.textColor = [UIColor blueColor] ;
        _countLabel.font = [UIFont systemFontOfSize:18] ;
        _countLabel.layer.cornerRadius = 3 ;
        _countLabel.layer.borderColor = [UIColor redColor].CGColor ;
        _countLabel.layer.borderWidth = 1 ;
        _countLabel.text = [NSString stringWithFormat:@"%d",count] ;
    }
    return _countLabel ;
}

- (BOOL)prefersStatusBarHidden
{
    return YES ;
}
@end
