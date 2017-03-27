
//
//  URConfigInfo.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "URConfigInfo.h"

@implementation URConfigInfo
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic] ;
    }
    return self ;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
