//
//  PersonInfo.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "PersonInfo.h"

@implementation PersonInfo

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    
    [encoder encodeObject:self.mobile forKey:@"mobile"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self ;
}

@end
