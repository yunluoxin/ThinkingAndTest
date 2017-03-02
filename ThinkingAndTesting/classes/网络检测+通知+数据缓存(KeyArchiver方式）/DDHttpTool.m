//
//  DDHttpTool.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 17/3/2.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDHttpTool.h"
#import "AFHTTPSessionManager.h"
#import "DDUtils+Security.h"

//缓存文件夹的名字
static NSString * const DDHttpToolCacheSavedDirectoryName = @"com.dadong.httptool.cache" ;

//缓存的全路径
#define DDHttpToolCacheSavedPath ([NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], DDHttpToolCacheSavedDirectoryName])

//API请求的共有部分
NSString * const DDBaseUrl = @"https://api.m.kachemama.com/mobile/" ;

@interface DDHttpTool ()


@end

@implementation DDHttpTool

+ (instancetype)sharedInstance
{
    static DDHttpTool * tool ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init ] ;
    });
    return tool ;
}

+ (void)GET_url:(NSString *)url parameters:(NSDictionary *)params needLogin:(BOOL)needLogin response:(void (^)(id responseObject, NSError * err))block
{
    [self url:url method:0 parameters:params needLogin:needLogin howToGetData:nil howToSaveData:nil response:block] ;
}

+ (void)POST_url:(NSString *)url parameters:(NSDictionary *)params needLogin:(BOOL)needLogin response:(void (^)(id responseObject, NSError * err))block
{
    [self url:url method:1 parameters:params needLogin:needLogin howToGetData:nil howToSaveData:nil response:block] ;
}

+ (void)PostWithJson_url:(NSString *)url parameters:(NSDictionary *)params needLogin:(BOOL)needLogin response:(void (^)(id responseObject, NSError * err))block
{
    [self url:url method:2 parameters:params needLogin:needLogin howToGetData:nil howToSaveData:nil response:block] ;
}

+ (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin howToGetData:(id (^)(void)) howToGetData howToSaveData:(void (^)(id _Nullable data)) howToSaveData response:(void (^)(id responseObject, NSError * err))block
{
    if (!url || url.length < 1) {
        return ;
    }
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:DDBaseUrl]] ;
    if (method == 2) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer] ;
        method = 1 ;    //也用post方式传
    }else{
        manager.requestSerializer = [AFHTTPRequestSerializer serializer] ;
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializer] ;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;   //打开状态栏网络指示器
    
    /*抽取GET和POST公用的失败时候执行的block方法*/
    void (^failure)(NSURLSessionDataTask* , NSError* ) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
        
        DDLog(@"%ld",error.code);
        if (error.code == -1011) { //这个无网络的错误码待确定
            
            //提示没网络
#warning to do
            
            if (block) {
                block(nil, error) ;
            }
            
        }else{
            if (block) {
                block(nil, error) ;
            }
        }
    };
    
    switch (method) {
        case 1: //POST
        {
            [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
                
#pragma mark 根据业务进行状态判断
                id status = responseObject[@"status"] ;
                
                NSNumber * code = [status valueForKey:@"code"] ;
                
                if (code && code.intValue != 0) {   //有错误代码出现，有错误
                    //有错误，加载错误描述
                    NSString * desc = [status valueForKey:@"error_desc"] ;
                    DDLog(@"\n【错误码】%@, 【错误内容】%@\n",code, desc) ;
                    
                    //展现错误
#warning - to do
                    if (block) {
                        block (responseObject, nil) ;
                    }
                    
                }else{                      //成功获取数据
                    if (block) {
                        block(responseObject, nil) ;
                    }
                    
                    //保存响应内容
                    [DDHttpTool saveCachedWithUrl:url response:responseObject needLogin:needLogin] ;
                }
                
            } failure:[failure copy]] ;
            break;
        }
        case 0: //GET
        {
            [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
                
#pragma mark 根据业务进行状态判断
                id status = responseObject[@"status"] ;
                
                NSNumber * code = [status valueForKey:@"code"] ;
                
                if (code && code.intValue != 0) {   //有错误代码出现，有错误
                    //有错误，加载错误描述
                    NSString * desc = [status valueForKey:@"error_desc"] ;
                    DDLog(@"\n【错误码】%@, 【错误内容】%@\n",code, desc) ;
                    
                    //展现错误
#warning - to do
                    
                    //加载缓存
                    id res = nil ;
                    if (howToGetData) {
                        res = howToGetData() ;
                    }else{
                        res = [DDHttpTool loadCachedWithUrl:url needLogin:needLogin] ;
                    }
                    
                    if (res) {  //缓存中存在数据，直接加载
                        if (block) {
                            block(res, nil) ;
                        }
                    }
                    
                }else{                      //成功获取数据
                    if (block) {
                        block(responseObject, nil) ;
                    }
                    
                    //保存响应内容
                    if (howToSaveData) {
                        howToSaveData(responseObject) ;
                    }else{
                        [DDHttpTool saveCachedWithUrl:url response:responseObject needLogin:needLogin] ;
                    }
                }
            } failure:[failure copy]] ;
            break ;
        }
        default:
            break;
    }
    
    
}


+ (BOOL)saveCachedWithUrl:(NSString *)url response:(id)responseObject needLogin:(BOOL)needLogin
{
    if (!url || url.length < 1 || !responseObject) {
        return NO ;
    }
    
    NSMutableString * strM = [NSMutableString string] ;
    if (needLogin) {
        if (YES) {
            [strM appendFormat:@"userId_%@_",@5] ;
        }else{
            //出错了！要登录却不在线
            return NO;
        }
    }
    
    [strM appendFormat:@"url_%@",url] ;
    ///到此为止，格式为 ==> userId_5555_url_home/data
    
    //进行MD5运算
    NSString * fileName = [DDUtils encrypt_MD5:strM] ;
    
    NSString * path = [DDHttpToolCacheSavedDirectoryName stringByAppendingPathComponent:fileName] ;
    
    BOOL result = [NSKeyedArchiver archiveRootObject:responseObject toFile:path] ;
    
    return result ;
}

+ (id)loadCachedWithUrl:(NSString *)url needLogin:(BOOL)needLogin
{
    if (!url || url.length < 1) {
        return nil ;
    }
    
    NSMutableString * strM = [NSMutableString string] ;
    if (needLogin) {
        if (YES) {
            [strM appendFormat:@"userId_%@_",@5] ;
        }else{
            //出错了！要登录却不在线
            return nil ;
        }
    }
    
    [strM appendFormat:@"url_%@",url] ;
    ///到此为止，格式为 ==> userId_5555_url_home/data
    
    //进行MD5运算
    NSString * fileName = [DDUtils encrypt_MD5:strM] ;
    
    NSString * path = [DDHttpToolCacheSavedDirectoryName stringByAppendingPathComponent:fileName] ;
    
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path] ;
    
    return obj ;
}

@end
