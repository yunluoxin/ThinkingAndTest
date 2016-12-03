//
//  ADManager.h
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADManager : NSObject


/**
    当前是否存在活动广告
    @return 广告存在则返回yes，不存在返回no
 */
+ (BOOL)existAD ;

+ (void)preDownloadActivity ;

@end
