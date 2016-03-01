//
//  LeftViewController.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawerLeftViewControllerDelegate <NSObject>

@optional
- (void)drawerLeftViewController:(UIViewController *)vc didSelectRowAtIndex:(NSInteger)index ;

@end

@interface LeftViewController : UIViewController

@property (nonatomic, weak) id <DrawerLeftViewControllerDelegate> delegate ;

@end
