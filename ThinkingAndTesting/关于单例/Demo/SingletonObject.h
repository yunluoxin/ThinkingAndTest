//
//  SingletonObject.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Singleton.h"
@interface SingletonObject : NSObject
@property (nonatomic, assign)int age ;
+ (instancetype)sharedObject ;

- (instancetype)initWithAge:(int)age ;
@end
