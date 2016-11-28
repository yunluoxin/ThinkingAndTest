//
//  TestEnum.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonObject.h"
@interface testEnum : NSObject
AS_SINGLETON()
@property (nonatomic, assign)int a ;
@property (nonatomic, assign)int b ;

@property (nonatomic, strong, readonly) testEnum * test1 ;
@property (nonatomic, strong, readonly) testEnum * test2 ;

@end

