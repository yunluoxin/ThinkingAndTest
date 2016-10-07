//
//  DDModel.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDModel.h"
#import "DDAppCache.h"
#import "AFHTTPSessionManager.h"

@implementation DDModel

static BOOL hasCheckedReachbility = NO ;//是否检测过网络可达性

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
    /*
        这里需要注意，AFNetwork的网络可达性检测，如果不调用底下的startMonitoring的话，检测出来的状态永远是无网络！所以放在其他环境中，必须确保在使用这个方法之前已经调用过startMonitoring
     */
    [m setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DDLog(@"检测出来");
        hasCheckedReachbility = YES ;
    }];
//    [m startMonitoring];
    
    __block NSDictionary *userinfo ;
    
    typeof(self) __weak weakSelf = self ;
    
    if (m.isReachable || !hasCheckedReachbility) {
        //网络可达
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;   //打开状态栏网络指示器
        
        /*抽取GET和POST公用的两个block方法*/
        void (^success)(NSURLSessionDataTask* , id) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            hasCheckedReachbility = YES ;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;    //关闭状态栏网络指示器
            
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
        };
        
        void (^failure)(NSURLSessionDataTask* , NSError* ) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
            
            DDLog(@"%ld",error.code);
            if (error.code == -1011) { //这个无网络的错误码待确定
                hasCheckedReachbility = YES ;
                
                //没网络
                [weakSelf noNetworkDoSomething:howToGetData filePath:filePath notificationName:notificationName];
                
            }else{
                //有网络无数据（出错）
                userinfo = @{
                             @"NetworkDataStatus":@(NetworkDataStatusHasNetworkNoData),
                             @"error":error.localizedDescription
                             };
                [[NSNotificationCenter defaultCenter]postNotificationName:notificationName object:nil userInfo:userinfo];
            }
        };
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        if (method == 1) {
            // POST方法
            [manager POST:url parameters:params constructingBodyWithBlock:nil progress:nil success:success failure:failure];
        }else{
            // 其他默认的都是GET方法
            [manager GET:url parameters:params progress:nil success:success failure:failure];
        }
        
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
- (void)dealloc
{
    DDLog(@"%@",@"32`");
}
@end
