//
//  URLoginViewController.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/28.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLoginViewController : UIViewController
/**
 *  <#note#>
 */
@property (nonatomic, copy)void (^whenPopVC)(BOOL loginResult) ;
@end
