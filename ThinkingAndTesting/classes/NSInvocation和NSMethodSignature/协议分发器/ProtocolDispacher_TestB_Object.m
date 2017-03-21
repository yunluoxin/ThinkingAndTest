
//
//  ProtocolDispacher_TestB_Object.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ProtocolDispacher_TestB_Object.h"
#import "ProtocolDispatcher_TestA_Object.h"

@interface ProtocolDispacher_TestB_Object () <ProtocolDispatcherTestDelegate>

@end

@implementation ProtocolDispacher_TestB_Object

- (void)printSomething
{
    DDLog(@"%@ , %s",self, __func__) ;
}

- (NSInteger)personInThisRoom
{
    return 10 ;
}


- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}
@end
