//
//  GestureViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "GestureViewController.h"
#import "UIButton+Block.h"
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"
@interface GestureViewController ()
@property (nonatomic, strong) UIView *purpleView ;

@property (nonatomic, assign)CGRect originFrame ;
@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    _purpleView = purpleView ;
    [self.view addSubview:purpleView];
    purpleView.frame = CGRectMake(self.view.dd_width/2, self.view.dd_height/2, self.view.dd_width/2, self.view.dd_height/2) ;
    purpleView.center = CGPointMake(self.view.dd_width/2, self.view.dd_height/2);
    _originFrame = _purpleView.frame ;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    [purpleView addGestureRecognizer:pan];
    
    
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        if (_purpleView.superview == nil) {
            [self.view addSubview:_purpleView];
            _purpleView.center = CGPointMake(self.view.dd_width/2, self.view.dd_height/2);
            _purpleView.alpha = 1 ;
        }
    }];
    [button setTitle:@"哈哈" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(100);
        make.top.equalTo(80);
        make.left.equalTo(20);
    }];
    
    
}

- (void)move:(UIPanGestureRecognizer *)pan
{
    UIView *animateView = pan.view ;
    CGPoint moveMent = [pan translationInView:self.view];
    [pan setTranslation:CGPointZero inView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint newPoint = [pan locationInView:_purpleView] ;
        CGPoint newAnchorPoint = CGPointMake(newPoint.x/_purpleView.bounds.size.width, newPoint.y/_purpleView.bounds.size.height);
        
        CGRect o = _purpleView.frame ;
        _purpleView.layer.anchorPoint = newAnchorPoint ;
        _purpleView.frame = o ;
        
    }else  if (pan.state == UIGestureRecognizerStateChanged) {
        _purpleView.center = CGPointMake(_purpleView.center.x + moveMent.x, _purpleView.center.y + moveMent.y );

        [UIView animateKeyframesWithDuration:2 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState|UIViewKeyframeAnimationOptionAllowUserInteraction|UIViewKeyframeAnimationOptionAutoreverse animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
                CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_4);
                _purpleView.transform = rotate ;
//                animateView.transform = CGAffineTransformRotate(animateView.transform, M_PI_4);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
//                CGAffineTransform rotate = CGAffineTransformMakeRotation(0);
//                _purpleView.transform = rotate ;
                animateView.transform = CGAffineTransformRotate(animateView.transform, -M_PI_4);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
//                CGAffineTransform rotate = CGAffineTransformMakeRotation(- M_PI_4);
//                _purpleView.transform = rotate ;
                animateView.transform = CGAffineTransformRotate(animateView.transform, -M_PI_4);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
//                CGAffineTransform rotate = CGAffineTransformMakeRotation(0);
//                _purpleView.transform = rotate ;
                animateView.transform = CGAffineTransformRotate(animateView.transform, M_PI_4);
            }];
        } completion:^(BOOL finished) {
//            _purpleView.transform = CGAffineTransformIdentity ;
        }];
    }else if(pan.state == UIGestureRecognizerStateEnded){
        CGPoint v = [pan velocityInView:self.view];
        
        CGFloat absV = MAX(ABS(v.x), ABS(v.y)); //求出横向和纵向速度的最大值
        
        if (absV > 300) {
            [UIView animateWithDuration:0.5 animations:^{
                _purpleView.alpha = 0 ;
                _purpleView.center = CGPointMake(DD_SCREEN_WIDTH/2 , DD_SCREEN_HEIGHT + _purpleView.dd_height/2 );
            } completion:^(BOOL finished) {
                [_purpleView removeFromSuperview];
            }];
            
        }else{
            [animateView.layer removeAllAnimations ];
            
            _purpleView.transform = CGAffineTransformIdentity ;
            CGRect o = _purpleView.frame ;
            _purpleView.layer.anchorPoint = CGPointMake(0.5, 0.5) ;
            _purpleView.frame = o ;
            
            
            [UIView animateWithDuration:0.5 animations:^{
                _purpleView.center = CGPointMake(self.view.dd_width/2, self.view.dd_height/2);
                animateView.transform = CGAffineTransformMakeRotation(-M_PI_4);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    animateView.transform = CGAffineTransformIdentity ;
                }];
            }];
        }
        
    }
}

@end
