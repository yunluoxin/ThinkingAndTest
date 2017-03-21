//
//  DDProtocolDispatcher.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

///
///     Learn this `ProtocolDispatcher` from https://github.com/panghaijiao/HJProtocolDispatcher
///


#import <Foundation/Foundation.h>

#define ProtocolDispatcher(protocol, ...) [DDProtocolDispatcher dispatchProtocol:@selector(protocol) toImplementors:[NSArray arrayWithObjects:__VA_ARGS__, nil]]

@interface DDProtocolDispatcher : NSObject

+ (instancetype)dispatchProtocol:(Protocol *)protocol toImplementors:(NSArray *)implementors ;

@end
