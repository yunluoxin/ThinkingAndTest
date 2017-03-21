//
//  ProtocolDispatcher_TestA_Object.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/21.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProtocolDispatcherTestDelegate <NSObject>

@required
- (void)printSomething ;

@optional
- (NSInteger)personInThisRoom ;

@end


@interface ProtocolDispatcher_TestA_Object : NSObject

/**
 *  <#note#>
 */
@property (nonatomic, weak) id<ProtocolDispatcherTestDelegate> delegate ;

- (void)startTest ;

@end
