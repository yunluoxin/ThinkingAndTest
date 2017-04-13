//
//  DDNavigationBar.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDNavigationBar : UIView

@property (strong, nonatomic) UIColor * titleColor ;
@property (strong, nonatomic) UIFont  * titleFont ;

@property (nonatomic, strong) UINavigationItem *navigationItem ;

@property (strong, nonatomic) UIColor * barTintColor ;

@property (strong, nonatomic) UIImage * backgroundImage ;

@property (assign, nonatomic) BOOL translucent ;

@end
