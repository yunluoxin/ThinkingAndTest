//
//  AnimalBehavior.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/8.
//  Copyright © 2016年 dadong. All rights reserved.
//

#ifndef AnimalBehavior_h
#define AnimalBehavior_h

@protocol AnimalBehaviorProtocol <NSObject>

@required
- (void)eat ;
- (void)run ;
- (void)walk ;

@optional
- (BOOL)isCute ;

@end
#endif /* AnimalBehavior_h */
