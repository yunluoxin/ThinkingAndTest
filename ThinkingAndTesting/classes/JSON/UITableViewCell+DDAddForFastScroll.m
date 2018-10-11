//
//  UITableViewCell+DDAddForFastScroll.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/11.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "UITableViewCell+DDAddForFastScroll.h"

#import <objc/runtime.h>

@implementation UITableViewCell (DDAddForFastScroll)

- (void)setDd_cellData:(id)dd_cellData {
    objc_setAssociatedObject(self, @selector(dd_cellData), dd_cellData, OBJC_ASSOCIATION_RETAIN);
}

- (id)dd_cellData {
    return objc_getAssociatedObject(self, @selector(dd_cellData));
}

@end
