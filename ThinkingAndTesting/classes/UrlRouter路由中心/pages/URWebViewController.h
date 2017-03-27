//
//  URWebViewController.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URWebViewController : UIViewController

/**
 H5的页面url, 优先级比下面的高
 */
@property (nonatomic, copy) NSString * h5PageUrl ;

/**
 普通的网页地址
 */
@property (nonatomic, copy) NSString * normalWebUrl ;

@end
