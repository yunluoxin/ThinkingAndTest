//
//  UIGestureRecognizer+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UIGestureRecognizer+DDAdd.h"

@interface _DDUIGestureRecognizerBlockTarget : NSObject
@property (nonatomic, copy) void (^block)(id sender) ;
@end

@implementation _DDUIGestureRecognizerBlockTarget

- (instancetype)initWithBlock:(void (^)(id sender))block
{
    if(self = [super init])
    {
        self.block = block;
    }
    return self ;
}

- (void)_p_action:(id)sender
{
    if(self.block) self.block(sender) ;
}
@end

@implementation UIGestureRecognizer (DDAdd)

- (instancetype)initWithActionBlock:(void (^)(id sender))block
{
    if (self = [self initWithTarget:nil action:nil])
    {
        [self _p_addActionBlock:block] ;
    }
    return self ;
}

- (void)_p_addActionBlock:(void (^)(id sender))block
{
    if (!block) return ;
    
    NSMutableArray * targets = [self _dd_allUIGestureRecognizerBlockTargets] ;
    _DDUIGestureRecognizerBlockTarget * target = [[_DDUIGestureRecognizerBlockTarget alloc] initWithBlock:block] ;
    [self addTarget:target action:@selector(_p_action:)] ;
    [targets addObject:target] ;
}

- (void)removeAllBlocks
{
    NSMutableArray * targets = [self _dd_allUIGestureRecognizerBlockTargets] ;
    for (id target in targets)
    {
        [self removeTarget:target action:NULL] ;
    }
    [targets removeAllObjects] ;
}


- (NSMutableArray *)_dd_allUIGestureRecognizerBlockTargets
{
    static char target_key ;
    NSMutableArray * targets = [self getAssociateValueByKey:&target_key] ;
    if(!targets)
    {
        targets = @[].mutableCopy ;
        [self setAssociateValue:targets forKey:&target_key] ;
    }
    return targets ;
}
@end
