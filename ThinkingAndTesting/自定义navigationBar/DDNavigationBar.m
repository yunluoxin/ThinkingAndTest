//
//  DDNavigationBar.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDNavigationBar.h"

@implementation DDNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self createView];
    }
    return self ;
}


- (void)createView
{
    
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];   //让导航栏成为透明的
    self.barTintColor = [UIColor clearColor];
    self.translucent = YES ;
    
    self.navigationItem = [[UINavigationItem alloc]initWithTitle:@"哈哈"];
    self.items = @[self.navigationItem];
    
//    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  ;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
}


@end
