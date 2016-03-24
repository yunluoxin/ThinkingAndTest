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
    return 0.5 ;
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
        
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            modalView.frame = endFrame ;
            modalView.alpha = 1 ;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        UIView *modalView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//        [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            modalView.transform = CGAffineTransformMakeScale(0.1, 0.1) ;
//            modalView.alpha = 0 ;
//        } completion:^(BOOL finished) {
//            [modalView removeFromSuperview];
//            [transitionContext completeTransition:YES];
//        }];
        
        UIView *snapShot = [modalView snapshotViewAfterScreenUpdates:NO];
        [modalView removeFromSuperview];
//        snapShot.frame = modalView.frame ;
        [containerView addSubview:snapShot];
        [containerView bringSubviewToFront:snapShot];
        
//        [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            snapShot.transform = CGAffineTransformMakeScale(0.1, 0.1);
//            snapShot.alpha = 0 ;
//        } completion:^(BOOL finished) {
//            [snapShot removeFromSuperview];
//            [transitionContext completeTransition:YES];
//        }];
        
        
        CGRect frame = snapShot.frame ;
        snapShot.layer.anchorPoint = CGPointMake(0.0, 1.0);
        snapShot.frame = frame ;
        [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            snapShot.transform = CGAffineTransformMakeRotation(M_PI);
            snapShot.alpha = 0 ;
        } completion:^(BOOL finished) {
            [snapShot removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
}
@end
