//
//  ProtocolDispatcher_TestA_Object.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ProtocolDispatcher_TestA_Object.h"

@implementation ProtocolDispatcher_TestA_Object

- (void)startTest
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(printSomething)]) {
        [self.delegate printSomething] ;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(personInThisRoom)]) {
        NSInteger persons = [self.delegate personInThisRoom] ;
        DDLog(@"sum = > %li persons in room", persons) ;
    }
}

@end
