//
//  URDemo_A_ViewController.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URDemo_A_ViewController : UIViewController

@property (nonatomic, strong) UIImage * image ;

@property (nonatomic, copy) void (^whenPopVC)(id value) ;

@end
