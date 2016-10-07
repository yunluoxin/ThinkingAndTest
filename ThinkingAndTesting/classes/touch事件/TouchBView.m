//
//  TouchBView.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/9/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TouchBView.h"

@implementation TouchBView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__) ;
    [super touchesBegan:touches withEvent:event] ;
}
@end
