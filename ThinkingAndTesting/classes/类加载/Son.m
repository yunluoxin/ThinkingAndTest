//
//  Son.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/5/8.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "Son.h"

@implementation Son

+ (void)load {
    DDLog(@"%s", __func__);
}

+ (void)initialize {
    DDLog(@"before invoke super");
    [super initialize];
    DDLog(@"%s", __func__);
}
@end
