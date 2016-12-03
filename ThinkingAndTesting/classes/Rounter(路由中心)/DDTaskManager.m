//
//  DDTaskManager.m
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDTaskManager.h"

@interface DDTaskManager ()
@property (nonatomic, strong) NSMutableArray<DDTask *> * tasks ;
@end

@implementation DDTaskManager

+ (instancetype)sharedManager
{
    static DDTaskManager * manger ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[DDTaskManager alloc]init] ;
        manger.tasks = [NSMutableArray array] ;
    });
    return manger ;
}

+ (void)addTask:(DDTask *)task
{
    [[DDTaskManager sharedManager].tasks addObject:task] ;
}

+ (void)executeAllTasks
{
    for (DDTask * task in [DDTaskManager sharedManager].tasks) {
        switch (task.type) {
            case DDTaskNewPageType:
            {
                [UrlRounter openUrl:task.pageUrl] ;
                break;
            }
            default:
                break;
        }
    }
    
    //移除所有对象，清空任务
    [[DDTaskManager sharedManager].tasks removeAllObjects] ;
}
@end
