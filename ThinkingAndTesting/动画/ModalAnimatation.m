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
        [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            modalView.frame = endFrame ;
            modalView.alpha = 1 ;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        UIView *modalView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        CGRect endFrame = CGRectMake(0,CGRectGetMaxY(containerView.frame), modalView.frame.size.width, modalView.frame.size.height );
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            modalView.frame = endFrame ;
            modalView.alpha = 0 ;
        } completion:^(BOOL finished) {
            [modalView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}
@end
