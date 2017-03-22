//
//  DDCopiableLabel.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/22.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDCopiableLabel.h"

@implementation DDCopiableLabel
{
    NSTimeInterval _touchBeganedTime ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self) {
        [self setupActions] ;
    }
    return self ;
}



- (void)setupActions
{
    self.userInteractionEnabled = YES ;
    UILongPressGestureRecognizer * gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)] ;
    [self addGestureRecognizer:gesture] ;
}

- (BOOL)canBecomeFirstResponder
{
    return YES ;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // This symbol `:` can't be lost ! `copy:` and `copy` are totally two different methods.
    if (action == @selector(copy:)) {
        return YES ;
    }
    
    return NO ;
}

- (void)copy:(id)sender
{
    if (!self.attributedText) {
        [UIPasteboard generalPasteboard].string = self.text ;
    }else{
        [UIPasteboard generalPasteboard].string = self.attributedText.string ;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder] ;
        UIMenuController * menu = [UIMenuController sharedMenuController] ;
        [menu setTargetRect:self.frame inView:self.superview] ;
        [menu setMenuVisible:YES animated:YES] ;
    }
    
}


@end
