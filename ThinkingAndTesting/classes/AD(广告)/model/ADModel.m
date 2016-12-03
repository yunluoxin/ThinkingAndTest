//
//  ADModel.m
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ADModel.h"
#import "DDManager.h"
static NSString * ADModelKey = @"ADModel.ad" ;

@implementation ADModel

+ (instancetype) defaultInstance
{
    static ADModel  *obj = nil ;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        obj = [[self alloc] init];
        [obj loadCache];
    });
    
    return obj;
}

- (void)setAd:(AD *)ad
{
    _ad = ad ;
    
    [self saveCache] ;
}

- (void)loadCache
{
    self.ad = [AD readFromUserDefaultsWithKey:ADModelKey];
}

- (void)saveCache
{
    [self.ad writeToUserDefaultsWithKey:ADModelKey] ;
}

- (void)clearCache
{
    [self.ad clearUserDefaultsWithKey:ADModelKey] ;
}

+ (void)preLoadAD
{
    NSString *urlStr = [NSString stringWithFormat:@"ad"];
    NSDictionary *dic = nil ;
    [[DDManager manager] GET:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //状态返回成功
        STATUS *status = [STATUS mj_objectWithKeyValues:[responseObject objectForKey:@"status"]];
        if (status && status.succeed.intValue==1 && !status.error_code) {
            //刷新成功
            AD * ad = [AD mj_objectWithKeyValues:[responseObject valueForKeyPath:@"data"]];
            //存储
            [ADModel defaultInstance].ad = ad ;
            //发通知
            POST_NOTIFICATION(DDPreLoadADNotification, (@{@"status":status,@"ad":ad}));
        }else{
            POST_NOTIFICATION(DDPreLoadADNotification, (@{@"status":status}));
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        DDLog(@"%@",error.localizedDescription);
        POST_NOTIFICATION(DDPreLoadADNotification, (@{@"error":error.localizedDescription}));
    }];
}

@end

NSString * const DDPreLoadADNotification = @"DDPreLoadADNotification" ;
