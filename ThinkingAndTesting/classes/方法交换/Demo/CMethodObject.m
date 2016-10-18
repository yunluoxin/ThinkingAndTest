//
//  CMethodObject.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/10/14.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CMethodObject.h"

@implementation CMethodObject
- (void)abc
{
    DDLog(@"CMethod的abc--%@",[NSDate date]) ;
    DDLog(@"%@",self) ;
}
@end
