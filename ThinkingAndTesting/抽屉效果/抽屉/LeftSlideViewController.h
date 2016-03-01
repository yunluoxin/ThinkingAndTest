//
//  LeftSlideViewController.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/16.
//  Copyright © 2016年 dadong. All rights reserved.
//  一个VC能否添加另外一个VC的View，不报错

#import <UIKit/UIKit.h>
#import "DrawerContants.h"
@interface LeftSlideViewController : UIViewController
- (instancetype)initWithLeftVC:(UIViewController *)leftVC andMainVC:(UIViewController *)mainVC ;
@end
