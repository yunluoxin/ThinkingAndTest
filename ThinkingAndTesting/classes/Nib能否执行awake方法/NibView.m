//
//  NibView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//  在VC的Xib中添加当前view时候，awakeFromNib执行了，但是-init没有执行！
//  说明了：-initWithCoder: 里面不会调用-init方法！所以，-initWithCoder和-init里面，都要分别初始化！
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
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
}
@end
