//
//  UIView+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UIView+DDAdd.h"

@implementation UIView (DDAdd)

- (UIImage *)snapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0) ;
    [self.layer renderInContext:UIGraphicsGetCurrentContext()] ;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0) ;
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterScreenUpdates] ;
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    return image ;
}

- (NSData *)snapshotPDF
{
    CGRect bounds = self.bounds ;
    NSMutableData * data = [NSMutableData data] ;
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data) ;
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL) ;
    CGDataConsumerRelease(consumer) ;
    CGPDFContextBeginPage(context, NULL) ;
    
    CGContextTranslateCTM(context, 0, bounds.size.height) ;
    CGContextScaleCTM(context, 1, -1) ;
    [self.layer renderInContext:context] ;

    CGPDFContextEndPage(context) ;
    CGPDFContextClose(context) ;
    CGContextRelease(context) ;
    return data ;
}

- (void)removeAllSubViews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)] ;
}

- (UIViewController *)viewController
{
    for (UIView * view = self ; view; view = view.superview)
    {
        UIResponder * responder = [view nextResponder] ;
        if(responder && [responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder ;
        }
    }
    return nil ;
}


- (void)addBlurEffect
{
    UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] ;
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:effect] ;
    effectView.frame = self.bounds ;
    effectView.tag = 1111 ;
    [self addSubview:effectView] ;
}

- (void)removeBlurEffect
{
    [self removeBlurEffectAnimated:NO] ;
}

- (void)removeBlurEffectAnimated:(BOOL)animated
{
    NSEnumerator<UIView *> * enumerator = [self.subviews objectEnumerator] ;
    UIView * subview ;
    while (subview = [enumerator nextObject]) {
        if ([subview isKindOfClass:[UIVisualEffectView class]] && subview.tag == 1111)
        {
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    subview.alpha = 0 ;
                } completion:^(BOOL finished) {
                    [subview removeFromSuperview] ;
                }] ;
            }else{
                [subview removeFromSuperview] ;
            }
            break ;
        }
    }
}
@end


#import <objc/runtime.h>
#import "NSLayoutConstraint+DDAdd.h"

static char DDOriginHiddenKey ;
@implementation UIView (DD_CollapseAndRestore)

- (BOOL)dd_originalHidden
{
    return [objc_getAssociatedObject(self, &DDOriginHiddenKey) boolValue] ;
}

- (void)setDd_originalHidden:(BOOL)dd_originalHidden
{
    objc_setAssociatedObject(self, &DDOriginHiddenKey, @(dd_originalHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

+ (void)collapseView:(UIView *)view ofConstraints:(NSArray<NSLayoutConstraint *> *)constraints
{
    NSAssert(view, @"view can't be nil") ;
    
    BOOL hasHeightConstraint = NO ;
    
    for (int i = 0; i < constraints.count; i ++) {
        NSLayoutConstraint * temp = constraints[i] ;
        // reserve constraint's constant
        temp.dd_originalConstant = temp.constant ;
        temp.constant = 0 ;
        if ((temp.firstItem == view && temp.firstAttribute == NSLayoutAttributeHeight && temp.secondItem == nil) || (temp.secondItem == view && temp.secondAttribute == NSLayoutAttributeHeight && temp.firstItem == nil)) {
            hasHeightConstraint = YES ;
        }
    }

    
    // hide all first level subviews
    for (UIView * subview in view.subviews) {
        subview.dd_originalHidden = subview.isHidden ;
        subview.hidden = YES ;
    }
    
    
    // if user provide constraints don't contain view's height constraint.
    if (!hasHeightConstraint) {
        
        // if view do contain height constraint, but user just forget provide. So we search all of view's constraints to find out.
        for (int i = 0; i < view.constraints.count; i ++) {
            NSLayoutConstraint * temp = view.constraints[i] ;
            if ((temp.firstItem == view && temp.firstAttribute == NSLayoutAttributeHeight && temp.secondItem == nil) || (temp.secondItem == view && temp.secondAttribute == NSLayoutAttributeHeight && temp.firstItem == nil)) {
                temp.dd_originalConstant = temp.constant ;
                temp.constant = 0 ;
                return ;
            }
        }
        
        // finally, we don't find it. it means this view don't contain height constraint. so we create one.
        NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0] ;
        [view addConstraint:heightConstraint] ;
    }
    
}

+ (void)restoreView:(UIView *)view ofConstraints:(NSArray<NSLayoutConstraint *> *)constranints
{
    NSAssert(view, @"view can't be nil") ;
    
    // restore all first level subviews
    for (UIView * subview in view.subviews) {
        subview.hidden = subview.dd_originalHidden ;
    }
    
    BOOL hasHeightConstraint = NO ;
    
    for (int i = 0; i < constranints.count; i ++) {
        NSLayoutConstraint * temp = constranints[i] ;
        // restore constraint's constant
        temp.constant = temp.dd_originalConstant ;
        temp.dd_originalConstant = 0 ;
        
        if ((temp.firstItem == view && temp.firstAttribute == NSLayoutAttributeHeight && temp.secondItem == nil) || (temp.secondItem == view && temp.secondAttribute == NSLayoutAttributeHeight && temp.firstItem == nil)) {
            hasHeightConstraint = YES ;
        }
    }
    
    // if user provide constraints don't contain view's height constraint.
    if (!hasHeightConstraint) {
        
        // if view do contain height constraint, but user just forget provide. So we search all of view's constraints to find out.
        for (int i = 0; i < view.constraints.count; i ++) {
            NSLayoutConstraint * temp = view.constraints[i] ;
            if ((temp.firstItem == view && temp.firstAttribute == NSLayoutAttributeHeight && temp.secondItem == nil) || (temp.secondItem == view && temp.secondAttribute == NSLayoutAttributeHeight && temp.firstItem == nil)) {
                
                // if constraint's property dd_originalConstant exist, it means this view have height constraint originally. Not we add it.
                if (temp.dd_originalConstant > 0) {
                    temp.constant = temp.dd_originalConstant ;
                    temp.dd_originalConstant = 0 ;
                }else{
                    // oppositely, the height constraint is added by us, remove it.
                    [view removeConstraint:temp] ;
                }
                return ;
            }
        }
        
        DDLog(@"may be there is an error happenning. due to it has no height constraint found")
    }
}

- (void)collapseOfConstraints:(NSArray<NSLayoutConstraint *> *)constranints
{
    [[self class] collapseView:self ofConstraints:constranints] ;
}

- (void)restoreOfConstraints:(NSArray<NSLayoutConstraint *> *)constranints
{
    [[self class] restoreView:self ofConstraints:constranints] ;
}


- (UIView *)addLineToPosition:(DDLineViewPosition)position frontOffset:(CGFloat)frontOffset behindOffset:(CGFloat)behindOffset
{
    UIView * lineView = [UIView new] ;
    lineView.backgroundColor = [UIColor blackColor] ;
    lineView.alpha = 0.6 ;
    lineView.translatesAutoresizingMaskIntoConstraints = NO ;
    CGFloat thickness = 1 / [UIScreen mainScreen].scale ;
    [self addSubview:lineView] ;
    
    switch (position) {
        case DDLineViewPositionTop:
        {
            NSLayoutConstraint * layoutTop = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0] ;
            NSLayoutConstraint * layoutRight = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:- behindOffset] ;
            NSLayoutConstraint * layoutLeft = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:frontOffset] ;
            NSLayoutConstraint * layoutHeight = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:thickness] ;
            [self addConstraints:@[layoutTop, layoutRight, layoutLeft, layoutHeight]] ;
            break;
        }
        case DDLineViewPositionBottom:
        {
            NSLayoutConstraint * layoutRight = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:- behindOffset] ;
            NSLayoutConstraint * layoutBottom = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant: 0] ;
            NSLayoutConstraint * layoutLeft = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:frontOffset] ;
            NSLayoutConstraint * layoutHeight = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:thickness] ;
            [self addConstraints:@[layoutRight, layoutBottom, layoutLeft, layoutHeight]] ;
            break;
        }
        case DDLineViewPositionLeft:
        {
            NSLayoutConstraint * layoutTop = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:frontOffset] ;
            NSLayoutConstraint * layoutBottom = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant: -behindOffset] ;
            NSLayoutConstraint * layoutLeft = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0] ;
            NSLayoutConstraint * layoutWidth = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:thickness] ;
            [self addConstraints:@[layoutTop, layoutBottom, layoutLeft, layoutWidth]] ;
            break;
        }
        case DDLineViewPositionRight:
        {
            NSLayoutConstraint * layoutTop = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:frontOffset] ;
            NSLayoutConstraint * layoutBottom = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant: -behindOffset] ;
            NSLayoutConstraint * layoutRight = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0] ;
            NSLayoutConstraint * layoutWidth = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:thickness] ;
            [self addConstraints:@[layoutTop, layoutBottom, layoutRight, layoutWidth]] ;
            break;
        }
        default:
            break;
    }
    return lineView ;
}

- (UIView *)addHorizontalLineAtTop:(BOOL)isAtTop
{
    if (isAtTop) {
        return [self addLineToPosition:DDLineViewPositionTop frontOffset:0 behindOffset:0] ;
    }else{
        return [self addLineToPosition:DDLineViewPositionBottom frontOffset:0 behindOffset:0] ;
    }
}

- (UIView *)addVerticalLineAtLeft:(BOOL)isAtLeft
{
    if (isAtLeft) {
        return [self addLineToPosition:DDLineViewPositionLeft frontOffset:0 behindOffset:0] ;
    }else{
        return [self addLineToPosition:DDLineViewPositionRight frontOffset:0 behindOffset:0] ;
    }
}

@end
