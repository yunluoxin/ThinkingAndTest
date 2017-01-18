//
//  NSObject+DDAddForARC.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSObject+DDAddForARC.h"

DDSYNTH_DUMMY_CLASS(NSObject_DDAddForArc)

#if __has_feature(objc_arc)
#error please add -fno-objc-arc to this file's compiler flags.
#endif

@implementation NSObject (DDAddForARC)

- (NSUInteger)arcDebugRetainCount
{
#ifdef DEBUG
    return self.retainCount ;
#else
    return 0 ;
#endif
}

- (void)arcDebugRetain
{
#ifdef DEBUG
    [self retain] ;
#endif
}

- (void)arcDebugRelease
{
#ifdef DEBUG
    [self release] ;
#endif
}


- (void)arcDebugAutoRelease
{
#ifdef DEBUG
    [self autorelease] ;
#endif
}

@end
