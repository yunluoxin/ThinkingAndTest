//
//  AutoSizeButton.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AutoSizeButton.h"

@implementation AutoSizeButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor greenColor];
    }
    return self ;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    CGSize size = [title sizeOfFont:[UIFont systemFontOfSize:13] maxWidth:DD_SCREEN_WIDTH maxHeight:50];
    self.dd_width = size.width + 3 ;
    self.dd_height = size.height ;
}

@end
