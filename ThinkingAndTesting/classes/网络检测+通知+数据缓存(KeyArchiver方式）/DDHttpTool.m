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

#pragma mark - Utils

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
    
    switch (method) {
        case 1: //POST
        {
            [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
                
                NSHTTPURLResponse * response = (NSHTTPURLResponse *)task.response ;
                
                NSError * error = [self handleResponse:responseObject withAutoShowError:YES] ;
                
                if (error) {   //有错误代码出现，有错误
                    if (block) {
                        block (responseObject, error) ;
                    }
                    
                }else{                      //成功获取数据
                    if (block) {
                        block(responseObject, nil) ;
                    }
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
                
                DDLog(@"%ld",error.code);
                if (error.code == -1011) { //这个无网络的错误码待确定
                    
                    //提示没网络
#warning to do
                }
                
                if (block) {
                    block(nil, error) ;
                }
                
            }] ;
            break;
        }
        case 0: //GET
        {
            [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
                
                NSError * error = [self handleResponse:responseObject withAutoShowError:YES] ;
                
                if (error) {   //有错误代码出现，有错误
                    //加载缓存
                    id res = nil ;
                    if (howToGetData) {
                        res = howToGetData() ;
                    }else{
                        res = [DDHttpTool loadCachedWithUrl:url params:params needLogin:needLogin] ;
                    }
                    
                    if (res) {  //缓存中存在数据，直接加载
                        if (block) {
                            block(res, error) ;
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
                        [DDHttpTool saveCachedWithUrl:url params:params response:responseObject needLogin:needLogin] ;
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;   //关闭状态栏网络指示器
                
                DDLog(@"%ld",error.code);
                if (error.code == -1011) { //这个无网络的错误码待确定
                    
                    //提示没网络
#warning to do
                    
                }
                
                if (block) {
                    id res = [DDHttpTool loadCachedWithUrl:url params:params needLogin:needLogin] ;
                    block (res, error) ;
                }
                
            }] ;
            break ;
        }
        default:
            break;
    }
    
    
}


#pragma mark - privte methods

/**
 对成功的响应，根据自己的业务情况，做出进一步的判断
 */
+ (id)handleResponse:(id)responseObject withAutoShowError:(BOOL)antoShowError
{
    NSError * error = nil ;
    
#pragma mark 根据业务进行状态判断

    id status = responseObject[@"status"] ;
    
    NSNumber * code = [status valueForKey:@"error_code"] ;
    
    if (code && ![code isKindOfClass:[NSNull class]] && code.intValue != 0) {   //有错误代码出现，有错误
        
        error = [NSError errorWithDomain:DDBaseUrl code:code.integerValue userInfo:responseObject] ;
        
        //展现错误
#warning - to do
        
        if (code.integerValue == 111) {
            //下线处理
            
            
        }
        
    }
    
    return error ;
}


#pragma mark - Tips

/**
 根据错误，生成提示字符串
 @warning 此方法只应该生成字符串，不对当前业务进行任何处理，否则一旦调用多次，就出错
 */
+ (NSString *)tipsFromError:(NSError *)error
{
    if (!error) {
        return nil ;
    }
    
    NSString * tipsStr = nil ;
    
    id status = error.userInfo[@"status"] ;
    
    if (status) {   //成功响应，但是有错误码时候的情况
        
        NSNumber * code = [status valueForKey:@"error_code"] ;
        NSString * error_desc = [status valueForKey:@"error_desc"] ;
        DDLog(@"\n【错误码】%@, 【错误内容】%@\n",code, error_desc) ;
        
        if (code.integerValue == 111) {             //未登录
            tipsStr = @"" ;
        }else if (code.integerValue == 222) {       //掉线了，过期登录
            tipsStr = @"掉线了" ;
        }else{
            tipsStr = error_desc ;
        }
        
    }else{          //正常的error
        if (error.localizedDescription) {
            tipsStr = error.localizedDescription ;
        }else{
            tipsStr = [NSString stringWithFormat:@"ErrorCode:%ld",error.code] ;
        }
    }
    
    return tipsStr ;
}



#pragma mark - Cache

//存储 网络访问结果
+ (BOOL)saveCachedWithUrl:(NSString *)url params:(NSDictionary *)params response:(id)responseObject needLogin:(BOOL)needLogin
{
    
    NSString * path = [self filePathWithUrl:url params:params needLogin:needLogin] ;
    
    if (path == nil) {
        return NO ;
    }
    
    BOOL result = [NSKeyedArchiver archiveRootObject:responseObject toFile:path] ;
    
    return result ;
}

//加载 上一次成功的网络访问结果
+ (id)loadCachedWithUrl:(NSString *)url params:(NSDictionary *)params needLogin:(BOOL)needLogin
{

    NSString * path = [self filePathWithUrl:url params:params needLogin:needLogin] ;
    
    if (path == nil) {
        return nil ;
    }
    
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path] ;
    
    return obj ;
}


/**
 通过请求地址、参数、是否需要登录，构造出一个唯一的文件地址
 */
+ (NSString *)filePathWithUrl:(NSString *)url params:(NSDictionary *)params needLogin:(BOOL)needLogin
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
    
    if (params && params.count > 0) {
        NSArray * keys = params.allKeys ;
        for (int i = 0 ; i < keys.count; i ++) {
            if (i == 0) {
                [strM appendFormat:@"?%@=%@",keys[i], params[keys[i]]] ;
            }else{
                [strM appendFormat:@"&%@=%@",keys[i], params[keys[i]]] ;
            }
        }
    }//到此为止，格式为 ==> userId_5555_url_home/data?a=b&c=5&c=6
    
    //进行MD5运算
    NSString * fileName = [DDUtils encrypt_MD5:strM] ;  //dea640a8fc3ceea104c1d41abae782f0
    DDLog(@"原来组合字符串=>%@, md5加密之后为=>%@",strM,fileName) ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL isDir = NO ;
        BOOL isCreated = [[NSFileManager defaultManager] fileExistsAtPath:DDHttpToolCacheSavedPath isDirectory:&isDir] ;
        if (!isCreated) {
            BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:DDHttpToolCacheSavedPath withIntermediateDirectories:YES attributes:nil error:nil] ;
            if (!result) {
                DDLog(@"创建文件夹失败!") ;
                return ;
            }else{
                DDLog(@"\n////==========次信息仅输出一次==========\n////创建的缓存文件夹路径为===>%@\n////======================\n",DDHttpToolCacheSavedPath) ;
            }
        }else{
            if (!isDir) {
                DDLog(@"无法存储，由于路径%@被占用",DDHttpToolCacheSavedPath) ;
                return ;
            }
        }
    });
    
    NSString * path = [DDHttpToolCacheSavedPath stringByAppendingPathComponent:fileName] ;
    
    return path ;
}

@end
