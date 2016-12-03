//
//  ADManager.m
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ADManager.h"
#import "ADModel.h"
@implementation ADManager

+ (BOOL)existAD
{
    AD * ad = [ADModel defaultInstance].ad ;
    if (ad && ad.code && ad.adImage) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init] ;
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss" ;
        
        NSDate * startDate = [dateFormatter dateFromString:ad.startTime] ;
        NSDate * endDate = [dateFormatter dateFromString:ad.endTime] ;
        NSDate * nowDate = [NSDate date] ;
        
        if ([startDate timeIntervalSinceDate:nowDate] <= 0 && [endDate timeIntervalSinceDate:nowDate] >= 0 ) {
            return YES ;
        }
    }
    return NO ;
}


+ (void)preDownloadActivity
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preLoadADResult:) name:DDPreLoadADNotification object:nil] ;
    
    //异步下载
    asyn_global(^{
        [ADModel preLoadAD] ;
    }) ;
}

+ (void)preLoadADResult:(NSNotification *)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    
    STATUS * status = note.userInfo[@"status"] ;
    if (!status) {
        //加载出错
        return ;
    }
    
    if (status && !status.error_code) {
        //加载广告成功
        AD * ad = note.userInfo[@"ad"] ;
        
        if (![ad.code isEqualToString:[ADModel defaultInstance].ad.code]) {
            [ADModel defaultInstance].ad = ad ;
        }
        
    }else{
        //加载广告失败
    }
    
}

@end
