//
//  ProtectAcessObject.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "ProtectAcessObject.h"

@implementation ProtectAcessObject

- (instancetype)init {
    if (self = [super init]) {
        _secret = @[@"w", @"t", @"f", @"k"];
    }
    return self;
}

- (void)print {
    DDLog(@"%@", items);
}
@end


@implementation ProtectAcessSubObject

- (void)test {
    items = @[].mutableCopy;
    [items addObject:@(3)];
    [items addObject:@(1)];
    [items addObject:@(0)];
}

@end
