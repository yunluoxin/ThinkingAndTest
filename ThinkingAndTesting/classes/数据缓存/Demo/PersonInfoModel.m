//
//  PersonInfoModel.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "PersonInfoModel.h"
#import "AFHTTPSessionManager.h"
#import "DDNotifications.h"
#import "PersonInfo.h"
@implementation PersonInfoModel
- (void)loadData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{
                          @"name":@"da"
                          };
    [manager POST:@"http://192.168.0.237:8182/mobile/goods?goods_id=5" parameters:dic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *data = [self createData];
        [[NSNotificationCenter defaultCenter]postNotificationName:[DDNotifications ERROR_NOT_NETWORK] object:nil userInfo:@{
                                                                                                                            @"data":data
                                                                                                                            }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DDLog(@"%ld--->%@",error.code,error.localizedDescription);
        if (error.code == -1009) {
            //无网络导致的访问失败
            [[NSNotificationCenter defaultCenter]postNotificationName:[DDNotifications DATA_ERROR_NOT_NETWORK] object:nil];
        }else {
            //其他原因，比如返回数据格式错误，协议错误等错误
            [[NSNotificationCenter defaultCenter]postNotificationName:[DDNotifications ERROR_NOT_NETWORK] object:nil userInfo:@{@"error":error.localizedDescription}];
        }
    }];
}

- (id)createData
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0 ; i < 100; i ++) {
        PersonInfo *info = [[PersonInfo alloc]init];
        info.name = [NSString stringWithFormat:@"姓名%d",i];
        info.mobile = [NSString stringWithFormat:@"1875%d343%d",i,i];
        [arrayM addObject:info];
    }
    return arrayM ;
}

@end
