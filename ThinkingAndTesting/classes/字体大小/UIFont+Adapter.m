//
//  UIFont+Adapter.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/31.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UIFont+Adapter.h"

@implementation UIFont (Adapter)
+ (instancetype) absoluteFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (instancetype) relativeFontOfSize:(CGFloat)fontSize
{
    if (DD_SCREEN_WIDTH == 320) {
        //iphone4 ,4s, 5, 5s
        return [UIFont systemFontOfSize:fontSize];
    }else if (DD_SCREEN_WIDTH == 375){
        //iphone6, 6s
        return [UIFont systemFontOfSize:fontSize];
    }else if (DD_SCREEN_WIDTH == 414){
        //iphone6 plus, 6s plus
        return [UIFont systemFontOfSize:DD_SCREEN_WIDTH/320*fontSize];
    }
    return [UIFont systemFontOfSize:fontSize];
}
@end
