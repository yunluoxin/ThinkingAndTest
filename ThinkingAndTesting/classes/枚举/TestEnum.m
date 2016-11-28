//
//  TestEnum.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TestEnum.h"

@interface testEnum ()

@property (nonatomic, strong, readwrite) testEnum * test1 ;
@property (nonatomic, strong, readwrite) testEnum * test2 ;

@end
@implementation testEnum
DEF_SINGLETON()

- (testEnum *)test1
{
    if (!_test1) {
        _test1 = [testEnum new] ;
    }
    return _test1 ;
}

- (testEnum *)test2
{
    if (!_test2) {
        _test2 = [testEnum new] ;
    }
    return _test2 ;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES ;
    }
    
    if (!object) {
        return NO ;
    }
    
    if ([object isKindOfClass:[testEnum class]] == NO) {
        return NO ;
    }
    
    testEnum * t = (testEnum *)object ;
    if (self.a == t.a && self.b == t.b ) {
        return YES ;
    }
    return NO ;
}
@end


