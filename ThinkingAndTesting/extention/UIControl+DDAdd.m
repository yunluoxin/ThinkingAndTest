//
//  UIControl+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/6.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UIControl+DDAdd.h"

@interface _UIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender) ;
@property (nonatomic, assign) UIControlEvents controlEvents ;

@end

@implementation _UIControlBlockTarget

- (instancetype)initWithControlEvents:(UIControlEvents)controlEvents andBlock:(void (^)(id sender)) block
{
    if (self = [super init]) {
        self.block = [block copy] ;
        self.controlEvents = controlEvents ;
    }
    return self ;
}

- (void)action:(id)sender
{
    if (self.block)  self.block(sender) ;
}

@end

@implementation UIControl (DDAdd)

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (!target || !action || !controlEvents) return ;
    NSSet *targets = [self allTargets] ;
    for (id currentTarget in targets) {
        NSArray<NSString *> * actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents] ;
        for (NSString * currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction) forControlEvents:controlEvents] ;
        }
    }
    
    [self addTarget:target action:action forControlEvents:controlEvents] ;
}

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block
{
    if(!controlEvents || !block) return ;
    
    NSMutableArray * arrayM = [self _dd_allUIControlBlockTargets] ;
    _UIControlBlockTarget * target = [[_UIControlBlockTarget alloc] initWithControlEvents:controlEvents andBlock:block] ;
    [self addTarget:target action:@selector(action:) forControlEvents:controlEvents] ;
    [arrayM addObject:target] ;
}

- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block
{
    [self removeAllBlocksForControlEvents:controlEvents] ;
    [self addBlockForControlEvents:controlEvents block:block] ;
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents
{
    if(!controlEvents) return ;
    
    UIControlEvents events = self.allControlEvents ;
    if(events & controlEvents)
    {
        NSMutableArray * targets = [self _dd_allUIControlBlockTargets] ;
        NSMutableArray * removes = @[].mutableCopy ;
        for(_UIControlBlockTarget * target in targets)
        {
            if (target.controlEvents & controlEvents)
            {
                UIControlEvents newEvents = target.controlEvents & (~controlEvents) ;
                if (newEvents)
                {
                    [self removeTarget:target action:NULL forControlEvents:controlEvents] ;
                    target.controlEvents = newEvents ;
                    [self addTarget:target action:@selector(action:) forControlEvents:newEvents] ;
                }
                else
                {
                    [self removeTarget:target action:NULL forControlEvents:controlEvents] ;
                    [removes addObject:target] ;
                }
            }
        }
        
        [targets removeObjectsInArray:removes] ;
    }
}

- (NSMutableArray *)_dd_allUIControlBlockTargets
{
    static char targets_key ;
    NSMutableArray * arrayM = [self getAssociateValueByKey:&targets_key] ;
    if (!arrayM)
    {
        arrayM = @[].mutableCopy ;
        [self setAssociateValue:arrayM forKey:&targets_key] ;
    }
    return arrayM ;
}
@end
