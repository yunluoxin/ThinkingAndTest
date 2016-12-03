//
//  ADModel.h
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonObject.h"
#import "AD.h"

@interface ADModel : NSObject
+ (instancetype)defaultInstance ;

@property (nonatomic, strong)AD * ad ;

/**
    预加载广告
 */
+ (void)preLoadAD ;

@end

extern NSString * const DDPreLoadADNotification ;
