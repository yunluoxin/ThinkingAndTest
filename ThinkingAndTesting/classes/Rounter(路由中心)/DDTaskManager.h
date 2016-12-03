//
//  DDTaskManager.h
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDTask.h"
@interface DDTaskManager : NSObject
+ (void)addTask:(DDTask *)task ;

+ (void)executeAllTasks ;
@end
