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
    
//    bar.barTintColor = [UIColor orangeColor] ; // 设置导航栏的背景颜色
    
    [bar setBackgroundImage:[UIImage imageWithColor:[[UIColor redColor] colorWithAlphaComponent:0.99]] forBarMetrics:UIBarMetricsDefault];   // 让导航栏成为透明的
    
    bar.tintColor = [UIColor yellowColor]; // 设置items的颜色（原始渲染颜色，比如，默认是蓝色的，SystemItem都能被改变），但不能改变文字的和自定义View的
    
    
    // 专为 self.navigation.title 改变样式设计， 不影响titleView
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor whiteColor] ,
                                  NSFontAttributeName:[UIFont systemFontOfSize:17]
                                  }];
    
    
    // 去掉导航栏底下的分割线
    [bar setShadowImage:[UIImage new]] ;
    
    
    
    // 设置UIBarButtonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance] ;
    
    // 更改items里面的文字和SystemItem的颜色
//    barItem.tintColor = [UIColor orangeColor] ;
    
    
    // 只能改变item上边的文字样式，不能改变SystemItem的
    NSDictionary *fontDic=@{
                            NSForegroundColorAttributeName:[UIColor whiteColor],// 设置barbutton里面字体的颜色
                            NSFontAttributeName:[UIFont systemFontOfSize:15],  // 粗体
                            };
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:fontDic
                           forState:UIControlStateHighlighted];
    
    
    // 设置返回键
    UIImage* image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    
    bar.backIndicatorImage = image ;
    bar.backIndicatorTransitionMaskImage = image ;
    
//    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-[UIScreen mainScreen].bounds.size.height, 0) forBarMetrics:UIBarMetricsDefault];
//    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, - [UIScreen mainScreen].bounds.size.height) forBarMetrics:UIBarMetricsDefault] ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit] ;

    //移除导航栏底下的分割线
//    for (UIView *view in self.navigationBar.subviews) {
//        if ([[view description] hasPrefix:@"<_UINavigationBarBackground"]) {
//            [view.subviews.lastObject removeFromSuperview];
//        }
//    }

//    self.navigationBar.barStyle = UIBaselineAdjustmentNone ;  //不建议！！！
    
    
//    [self.navigationBar setShadowImage:[UIImage new]] ;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent ;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        self.hidesBottomBarWhenPushed = YES ;
        
        //
        // 这才是合理的方法。如果用之前的方法，会导致，上一页的title很长时候，到了下一页，返回虽然看不见了，但是当前的title会向右偏移很厉害。
        // Set the next page's back button having no text !!!
        // @warning 试过直接用self.topViewController.navigationItem.backBarButtonItem = nil ; 无效
        //
        self.topViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil] ;
    }
    
    [super pushViewController:viewController animated:animated] ;
}
@end
