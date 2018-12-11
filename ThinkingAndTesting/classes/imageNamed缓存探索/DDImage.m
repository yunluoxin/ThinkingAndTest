//
//  DDImage.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/4.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "DDImage.h"
#import <objc/runtime.h>

@implementation DDImage

- (void)dealloc {
    DDLog(@"%s", __func__);
}

@end

@implementation UIImage (TestDealloc)

DD_DYNAMIC_PROPERTY_TYPE(DDImage *, test, setTest, RETAIN_NONATOMIC)

@end
