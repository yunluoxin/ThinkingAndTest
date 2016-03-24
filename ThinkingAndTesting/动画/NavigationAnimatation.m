//
//  NavigationAnimatation.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NavigationAnimatation.h"

@implementation NavigationAnimatation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5 ;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];

    
    if (self.type == AnimatationTypeAppear) {

        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [containerView insertSubview:toView aboveSubview:fromView];
        
        
        toView.transform = CGAffineTransformMakeScale(0, 0);
        toView.alpha = 1 ;
        
        [UIView animateWithDuration:0.5 animations:^{
            toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            toView.alpha = 1 ;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *snapShot = [fromView snapshotViewAfterScreenUpdates:NO];
        [fromView removeFromSuperview];
        [containerView addSubview:snapShot];
        
        [containerView insertSubview:toView belowSubview:snapShot];
        
        [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            snapShot.transform = CGAffineTransformMakeScale(0.1, 0.1) ;
            snapShot.alpha = 0 ;
        } completion:^(BOOL finished) {
            [snapShot removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
}
@end
