//
//  UIViewController+Router.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/3/21.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "UIViewController+Router.h"

@implementation UIViewController (Router)

- (void)routeEvent:(NSString *)eventName withInfo:(NSDictionary *)info {
    // 新增沿着导航栈和present传递
    UIViewController *nextPage = nil;
    if (self.presentingViewController) {
        nextPage = self.presentingViewController;
        // 如果nextPage是UITabBarController,就取平行栈中被选择的那个
        if ([nextPage isKindOfClass:UITabBarController.class]) {
            UITabBarController *tabbarVC = (UITabBarController *)nextPage;
            nextPage = tabbarVC.selectedViewController;
        }
        // 如果nextPage是UINavigationController,就取栈上最顶层那个
        if ([nextPage isKindOfClass:UINavigationController.class]) {
            UINavigationController *nav = (UINavigationController *)nextPage;
            nextPage = nav.viewControllers.lastObject;
        }
    } else if (self.navigationController) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {
            nextPage = self.navigationController.viewControllers[index - 1];
        }
        // index == 0, 说明现在是导航栈最底层了，不需要沿着导航栈往下传递了
    }
    
    if (nextPage) {
        [nextPage routeEvent:eventName withInfo:info];
    } else {
        [super routeEvent:eventName withInfo:info]; ///< 原来的事件链(UIResponder+Router)继续传递
    }
}

@end
