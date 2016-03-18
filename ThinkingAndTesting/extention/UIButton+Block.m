//
//  UIButton+Block.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

const void* buttonBlockKey ;

@implementation UIButton (Block)
+ (instancetype)buttonWithBlock:(block)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    objc_setAssociatedObject(button, buttonBlockKey, target, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [button addTarget:button action:@selector(didSelfClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button ;
}

- (void)didSelfClicked:(UIButton *)sender
{
    block target = objc_getAssociatedObject(self, buttonBlockKey);
    if (target) {
        target(self);
    }
}

- (void)removeTargetOfBlock
{
    objc_setAssociatedObject(self, buttonBlockKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(didSelfClicked:) forControlEvents:UIControlEventTouchUpInside];
}
@end
