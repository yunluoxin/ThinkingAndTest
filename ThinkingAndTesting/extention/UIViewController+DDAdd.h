//
//  UIViewController+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/17.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DDAdd)
/// ===========================================================
///   针对处在导航栈中的视图控制器的导航
///   调用者是就是当前页面VC，不要用self.navigationController调用
/// ===========================================================

/**
 关闭当前页面,导航到某个页面
 @param page 某个页面
 */
- (void)dd_redirectTo:(UIViewController *)page ;

/**
 导航到某个页面（不关闭当前页面）
 @param page 某个页面
 */
- (void)dd_navigateTo:(UIViewController *)page ;

/**
 返回,即关闭当前页面
 */
- (void)dd_navigateBack ;

/**
 后退delta个页面，返回到当前导航栈内的某个页面
 以当前页面为0，1就是退后一页. 若是delta大于总页面数，即退回到第一个页面
 @param delta 返回的页面数
 */
- (void)dd_navigateBack:(NSInteger)delta ;

/**
 后退到某个指定名字的页面
 @warning 若栈中有多个页面都是同样的名字，默认只后退到栈顶上的页面
 @param pageName 页面的类名
 */
- (void)dd_navigateBackToPageByName:(NSString *)pageName ;

/**
 关闭当前导航栈中的某几个页面
 @warning 若是当前栈中有多个页面是同样的名字，默认都会被关闭
 @param pageNames 要关闭页面的类名，如@[@"DD_H5Page_ViewController",@"DD_WrongPage_ViewController"]
 */
- (void)dd_closeSomePagesByNames:(NSArray<NSString *> *)pageNames ;


@end
