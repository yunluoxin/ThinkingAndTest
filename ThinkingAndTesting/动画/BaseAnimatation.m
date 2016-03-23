//
//  BaseAnimatation.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/23.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "BaseAnimatation.h"

@implementation BaseAnimatation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1 ;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    NSAssert(NO, @"animateTransition: 动画方法必须由子类实现!");
}

@end
