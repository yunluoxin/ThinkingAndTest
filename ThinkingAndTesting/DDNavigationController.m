//
//  DDNavigationController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDNavigationController.h"

@interface DDNavigationController ()
@property (nonatomic, strong) UIView *backgroundView ;
@end

@implementation DDNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        UINavigationBar *bar = [UINavigationBar appearance] ;
        bar.barTintColor = [UIColor orangeColor] ;//设置导航栏背景颜色
        [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];   //让导航栏成为透明的
        bar.tintColor = [UIColor blackColor]; //设置View颜色
        bar.translucent = NO ;
        [bar setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName:[UIColor whiteColor],//设置title的颜色
                                      NSFontAttributeName:[UIFont systemFontOfSize:17]
                                      }];
        
        
        //设置UIBarButtonItem的外观
        UIBarButtonItem *barItem=[UIBarButtonItem appearance];
        //item上边的文字样式
        NSDictionary *fontDic=@{
                                NSForegroundColorAttributeName:[UIColor whiteColor],//设置barbutton里面字体的颜色
                                NSFontAttributeName:[UIFont systemFontOfSize:15],  //粗体
                                };
        [barItem setTitleTextAttributes:fontDic
                               forState:UIControlStateNormal];
        [barItem setTitleTextAttributes:fontDic
                               forState:UIControlStateHighlighted];
        
        //设置返回键
        UIImage* image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        bar.backIndicatorImage = image ;
        bar.backIndicatorTransitionMaskImage = image ;
        [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, 0) forBarMetrics:UIBarMetricsDefault];
    }
    return self ;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *bar = [UINavigationBar appearance] ;
    bar.barTintColor = [UIColor orangeColor] ;//设置导航栏背景颜色
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];   //让导航栏成为透明的
    bar.tintColor = [UIColor blackColor]; //设置View颜色
    bar.translucent = NO ;
    //移除导航栏底下的分割线
    for (UIView *view in self.navigationBar.subviews) {
        if ([[view description] hasPrefix:@"<_UINavigationBarBackground"]) {
            [view.subviews.lastObject removeFromSuperview];
        }
    }
}


- (void)setBackgroundColorAlpha:(CGFloat )alpha
{
    if (alpha == 0 ) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil ;
        return ;
    }
    UIColor *color = self.navigationBar.barTintColor;
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, self.navigationBar.dd_width, 64)];
        self.backgroundView.backgroundColor = color;
        [self.navigationBar insertSubview:self.backgroundView atIndex:1];       //这里是关键点！必须插入在Index=0或者1的上面，否则会被默认的背景view覆盖！插入太后面，会遮住导航栏上的items
    }
    self.backgroundView.backgroundColor = [color colorWithAlphaComponent:alpha];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent ;
}
@end
