//
//  CrossSecondViewController.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrossSecondViewController : UIViewController
@property (nonatomic, copy) void (^whenPopVC)(NSString *) ;

@property (nonatomic, weak)UIViewController *backVC ;
@end
