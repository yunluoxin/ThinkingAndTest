//
//  NSObject+DDModel.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/27.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NSObject+DDModel.h"
#import "DDAppCache.h"
#import "AFHTTPSessionManager.h"

@implementation NSObject (DDModel)

- (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin fileName:(NSString *)fileName howToGetData:(id (^)(void)) howToGetData howToSaveData:(void (^)(id _Nullable data)) howToSaveData notificationName:( NSString * _Nonnull )notificationName
{
    //登录判断
    NSString *filePath ;
    if (needLogin) {
        //是否已经登录
        if (NO) {//非法访问
            return ;
        }else{
            NSString *userName = @"xiaodong";
            filePath = [DDAppCache filePathWithUserName:userName andFileName:fileName];
        }
    }else{
        filePath = [DDAppCache filePathWithUserName:nil andFileName:fileName];
    }
    
    //检测网络可达性（可以封装）
    AFNetworkReachabilityManager *m = [AFNetworkReachabilityManager sharedManager];
    
//    [m setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        DDLog(@"AFNetworkReachabilityStatus--->%ld",status);
//    }];
//    [m startMonitoring];
    __block NSDictionary *userinfo ;
    
    __weak typeof(self) weakSelf = self ;
    if (m.isReachable) {
        //有网络
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:params constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //有网络有数据
            
            userinfo = @{
                         @"NetworkDataStatus":@(NetworkDataStatusHasNetworkHasData),
                         @"data":responseObject
                         };
            
            [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil userInfo:userinfo];
            
            if (howToSaveData) {
                howToSaveData(responseObject);
            }else{
                //默认方式存数据，存储成字典
                [DDAppCache saveAnyObject:responseObject toFilePath:filePath];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == 4001) { //这个错误码待确定
                //没网络
                [weakSelf noNetworkDoSomething:howToGetData filePath:filePath notificationName:notificationName];
                
            }else{
                //有网络无数据（出错）
                userinfo = @{
                             @"NetworkDataStatus":@(NetworkDataStatusHasNetworkNoData),
                             @"error":error.description
                             };
                [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil userInfo:userinfo];
            }
        }];
        
        
    }else{
        //无网络
        [self noNetworkDoSomething:howToGetData filePath:filePath notificationName:notificationName];
    }
}

//私有方法
- (void)noNetworkDoSomething:(id (^)(void)) howToGetData filePath:(NSString *)filePath notificationName:(NSString *)notificationName
{
    id data ;
    
    if (howToGetData) {
        data = howToGetData();
    }else{
        //默认方式取数据（取回字典类型）
        data = [DDAppCache objectWithFilePath:filePath];
    }
    
    NSDictionary *userinfo ;
    if (data) {
        //无网络有数据
        userinfo= @{
                    @"NetworkDataStatus":@(NetworkDataStatusNoNetworkHasData),
                    @"data":data
                    };
    }else{
        //无网络无数据
        userinfo  = @{
                      @"NetworkDataStatus":@(NetworkDataStatusNoNetworkNoData)
                      };
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil userInfo:userinfo];
}

- (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin notificationName:(NSString *)notificationName
{
    [self url:url method:method parameters:params needLogin:needLogin fileName:nil howToGetData:nil howToSaveData:nil notificationName:notificationName];
}

- (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin fileName:(NSString *)fileName notificationName:(NSString *)notificationName
{
    [self url:url method:method parameters:params needLogin:needLogin fileName:fileName howToGetData:nil howToSaveData:nil notificationName:notificationName];
}
@end
