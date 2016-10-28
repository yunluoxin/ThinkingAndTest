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

- (void)commonInit
{
    UINavigationBar *bar = self.navigationBar ;
    //        bar.barTintColor = [UIColor orangeColor] ;//设置导航栏背景颜色
    [bar setBackgroundImage:[UIImage imageWithColor:[[UIColor redColor] colorWithAlphaComponent:0.99]] forBarMetrics:UIBarMetricsDefault];   //让导航栏成为透明的
    bar.tintColor = [UIColor blackColor]; //设置items的颜色
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit] ;

    //移除导航栏底下的分割线
    for (UIView *view in self.navigationBar.subviews) {
        if ([[view description] hasPrefix:@"<_UINavigationBarBackground"]) {
            [view.subviews.lastObject removeFromSuperview];
        }
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent ;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        self.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated] ;
}
@end
