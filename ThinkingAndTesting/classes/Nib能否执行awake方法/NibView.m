//
//  NibView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NibView.h"

@implementation NibView
- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"init方法");
        NibView *view = [[[NSBundle mainBundle]loadNibNamed:@"NibView" owner:nil options:nil]lastObject];
        return view ;
    }
    return self ;
}

- (void)awakeFromNib
{
    NSLog(@"awakeFromNib");
}
@end
