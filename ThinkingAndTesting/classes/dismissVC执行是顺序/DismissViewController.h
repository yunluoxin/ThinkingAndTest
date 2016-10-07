//
//  DismissViewController.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DismissViewController : UIViewController

@property (nonatomic, copy) void (^whenPopVC)() ;

@end
