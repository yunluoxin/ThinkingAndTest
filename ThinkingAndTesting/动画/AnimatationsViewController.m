//
//  AnimatationsViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/23.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AnimatationsViewController.h"
#import "UIButton+Block.h"
#import "MasonyDemoViewController.h"
#import "ModalAnimatation.h"
@interface AnimatationsViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, weak)UIView *purpleView ;
@property (nonatomic, strong)UIView *purpleView2 ;

@property (nonatomic,strong)ModalAnimatation *modelController ;
@end

@implementation AnimatationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelController = [[ModalAnimatation alloc]init];
    
    UIView *purpleView = [UIView new];
    purpleView.backgroundColor = [UIColor purpleColor];
    purpleView.frame = CGRectMake(0, 508, 100, 50);
    [self.view addSubview:purpleView];
    _purpleView = purpleView ;
    
    UIView *purpleView2 = [UIView new];
    purpleView2.backgroundColor = [UIColor yellowColor];
    purpleView2.frame = CGRectMake(0, 200, 100, 50);
    _purpleView2 = purpleView2 ;

    
    UIButton *button = [UIButton buttonWithBlock:^(UIButton *button) {
        [self click];
    }];
    button.frame = CGRectMake(0, 50, 100, 50);
    button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)click
{
//    [self method1];
    
//    [self method2];
    
//    [self method3];
    
//    [self method4];
    
//    [self method5];
    
//    [self method6];
    
    [self testPresentAnimatation];
}
- (void)testPresentAnimatation
{
    
    
    MasonyDemoViewController *vc = [[MasonyDemoViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.transitioningDelegate = self ;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _modelController.type = AnimatationTypeAppear ;
    return _modelController ;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _modelController.type = AnimatationTypeDisappear ;
    return _modelController ;
}

//利用闭包方式
- (void)method1
{
    [UIView beginAnimations:@"abc" context:nil];
    
    //设置执行时间
    [UIView setAnimationDuration:0.5];
    
    //设置动画效果（曲线）
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    /**
     *  想要让动画开始和结束执行方法，必须设置这个！！！否则底下的方法都无法执行！
     */
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationWillStartSelector:@selector(willStart:context:)];   //方法时候可以多传递一个动画名字,还可以再传递context
    
    [UIView setAnimationDidStopSelector:@selector(didStop)];
    
    _purpleView.center = CGPointMake(150, 64);
    
    [UIView commitAnimations];
}

//利用block
- (void)method2
{
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        //将改变视图属性的代码放在这个block中
        
        _purpleView.center = CGPointMake(150, 64);
    } completion:^(BOOL finished) {
        
    }];
}

//过渡动画
-(void)method3
{
    
    [UIView transitionWithView:_purpleView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        [_purpleView removeFromSuperview];
    }];
}

//两个view之间的过渡动画
-(void)method4
{
    [UIView transitionFromView:_purpleView toView:_purpleView2 duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        DDLog(@"%@%@",_purpleView,_purpleView2.superview);
    }];
}

//KeyFrame动画
-(void)method5
{
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
            _purpleView.center = CGPointMake(100, 300);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
            _purpleView.center = CGPointMake(150, 400);
        }];
    } completion:^(BOOL finished) {
        
    }];
}


-(void)method6
{
    _purpleView.center = CGPointMake(150, 64);
    UIView *snapshot = _purpleView ;
    [UIView animateKeyframesWithDuration:3 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0.0
//                                relativeDuration:0.15 animations:^{
//                                    //顺时针旋转90度
//                                    snapshot.transform = CGAffineTransformMakeRotation(-M_PI_2);
//                                }];
//        [UIView addKeyframeWithRelativeStartTime:0.15
//                                relativeDuration:0.10 animations:^{
//                                    //180度
//                                    snapshot.transform = CGAffineTransformMakeRotation(M_PI );
//                                }];
//        [UIView addKeyframeWithRelativeStartTime:0.25
//                                relativeDuration:0.20 animations:^{
//                                    //摆过中点，225度
//                                    snapshot.transform = CGAffineTransformMakeRotation(M_PI *
//                                                                                       1.3);
//                                }];
//        [UIView addKeyframeWithRelativeStartTime:0.45
//                                relativeDuration:0.20 animations:^{
//                                    //再摆回来，140度
//                                    snapshot.transform = CGAffineTransformMakeRotation(M_PI *
//                                                                                       0.8);
//                                }];
        [UIView addKeyframeWithRelativeStartTime:0.65
                                relativeDuration:0.35 animations:^{
                                    //旋转后掉落
                                    //最后一步，视图淡出并消失
                                    CGAffineTransform shift =
                                    CGAffineTransformMakeTranslation(180.0, 0.0);
                                    CGAffineTransform rotate =
                                    CGAffineTransformMakeRotation(M_PI * 0.3);
                                    snapshot.transform = CGAffineTransformConcat(shift,
                                                                                 rotate);
//                                    snapshot.alpha = 0.0;
                                }];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)willStart:(NSString*)sender context:(void*)context
{
    DDLog(@"即将开始%@",sender);
    if (context) {
        DDLog(@"%@",[NSString stringWithUTF8String:context]);
    }
}

- (void)didStop
{
    DDLog(@"停止动画「」");
}
@end
