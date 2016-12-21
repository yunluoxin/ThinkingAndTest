//
//  DeleteModel.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/12/6.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DeleteModel.h"

@implementation DeleteModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@",self.name] ;
}

- (void)dealloc
{
    NSLog(@"%@---dealloc",[self description]) ;
}
@end
