//
//  ModalAnimatation.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/23.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ModalAnimatation.h"

@implementation ModalAnimatation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1 ;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    
    if (self.type == AnimatationTypeAppear) {
        UIView *modalView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView addSubview:modalView];
        CGRect endFrame = modalView.frame ;
        
        modalView.frame = CGRectMake(endFrame.origin.x, CGRectGetMaxY(containerView.frame), endFrame.size.width, endFrame.size.height);
        modalView.alpha = 0 ;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            modalView.frame = endFrame ;
            modalView.alpha = 1 ;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        UIView *modalView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *snapShot = [modalView snapshotViewAfterScreenUpdates:NO];
        [modalView removeFromSuperview];
        [containerView addSubview:snapShot];
        [containerView bringSubviewToFront:snapShot];
        
//        CGRect frame = snapShot.frame ;
//        snapShot.layer.anchorPoint = CGPointMake(0.0, 0.5);
//        snapShot.frame = frame ;
//        [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            snapShot.transform = CGAffineTransformMakeRotation(M_PI);
//            snapShot.alpha = 0 ;
//        } completion:^(BOOL finished) {
//            [snapShot removeFromSuperview];
//            [transitionContext completeTransition:YES];
//        }];
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{

            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.4 animations:^{
                snapShot.transform = CGAffineTransformMakeRotation(M_PI*0.9);
                snapShot.alpha = 0.8 ;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.2 animations:^{
                snapShot.transform = CGAffineTransformMakeRotation(M_PI*1.2);
                snapShot.alpha = 0.6 ;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.2 animations:^{
                snapShot.transform = CGAffineTransformMakeRotation(M_PI*1);
                snapShot.alpha = 0.5 ;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
                snapShot.transform = CGAffineTransformMakeRotation(M_PI*0.8);
                snapShot.alpha = 0 ;
            }];
        } completion:^(BOOL finished) {
            [snapShot removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}
@end
