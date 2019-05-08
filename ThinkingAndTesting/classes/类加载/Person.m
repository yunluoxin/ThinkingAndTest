//
//  Person.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/5/8.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (void)load {
    DDLog(@"%s", __func__);
}

+ (void)initialize {
    DDLog(@"%s", __func__);
}
@end

@implementation Person(DD)


+ (void)load {
    DDLog(@"%s", __func__);
}

+ (void)initialize {
    DDLog(@"%s", __func__);
}

@end
