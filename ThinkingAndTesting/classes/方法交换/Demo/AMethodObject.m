//
//  AMethodObject.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AMethodObject.h"

@implementation AMethodObject

- (void)abc
{
    [super abc];
    DDLog(@"AMethod的abc--%@",[NSDate date]) ;
    DDLog(@"%@",[self class]) ;
}
@end
