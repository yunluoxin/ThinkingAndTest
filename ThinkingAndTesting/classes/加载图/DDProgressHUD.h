//
//  DDProgressHUD.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingletonObject.h"
@interface DDProgressHUD : UIView
AS_SINGLETON(DDProgressHUD)
- (void)beginAnimatation ;
- (void)stopAnimatation;

- (void)showStatus:(NSString *)status onlyInView:(UIView *)view ;
@end
