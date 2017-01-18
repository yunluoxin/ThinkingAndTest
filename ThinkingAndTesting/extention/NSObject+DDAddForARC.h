//
//  NSObject+DDAddForARC.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DDAddForARC)

- (NSUInteger)arcDebugRetainCount ;

- (void)arcDebugRetain ;

- (void)arcDebugRelease ;

- (void)arcDebugAutoRelease ;

@end
