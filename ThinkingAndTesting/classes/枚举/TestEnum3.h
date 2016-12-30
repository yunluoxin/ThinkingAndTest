//
//  TestEnum3.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger OrderStatus;

typedef NSString * DDPropertyKey NS_EXTENSIBLE_STRING_ENUM ;

FOUNDATION_EXPORT OrderStatus const OrderStatusDelived ;

FOUNDATION_EXPORT DDPropertyKey const DDPropertyAttributeName ;

@interface TestEnum3 : NSObject

@end
