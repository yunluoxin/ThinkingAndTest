//
//  XDProgressHUD.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface XDProgressHUD : MBProgressHUD
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay ;
- (void)hideAnimated:(BOOL)animated ;
@end
