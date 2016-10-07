//
//  NSObject+DDModel.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/27.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NetworkDataStatusNoNetworkNoData    =    0,
    NetworkDataStatusNoNetworkHasData   =    1,
    NetworkDataStatusHasNetworkNoData   =    2,
    NetworkDataStatusHasNetworkHasData  =    4
}NetworkDataStatus;


@interface NSObject (DDModel)

/**
 *  此方法直接访问网络数据，不在本地获取数据，也不存储数据
 *
 *  @param url              地址
 *  @param method           访问方式（暂时没用）
 *  @param params           访问的参数
 *  @param needLogin        是否需要登录
 *  @param notificationName 抛出的通知名
 */
- (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin notificationName:( NSString * _Nonnull )notificationName ;

/**
 *  此方法按照默认的方法存储与取出数据。
 *
 *  @param url              地址
 *  @param method           访问方式（暂时没用）
 *  @param params           访问的参数
 *  @param needLogin        是否需要登录
 *  @param fileName         文件名（存储和取出的文件名，置空代表不存储也取不到值）
 *  @param notificationName 抛出的通知名
 */
- (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin fileName:(NSString *)fileName notificationName:( NSString * _Nonnull )notificationName ;


/**
 *  便捷的一个缓存与访问网络方法。 抛出的userInfo带data和status两个key.
 其中data如果是访问网络的则是将网络访问的整个json数据抛出
 status是枚举NetworkDataStatus的一个状态
 *
 *  @param url              地址
 *  @param method           访问方式（暂时没用）
 *  @param params           访问的参数
 *  @param needLogin        是否需要登录
 *  @param fileName         文件名（存储和取出的文件名，置空代表不存储也取不到值）
 *  @param howToGetData     怎么获取数据，返回取到的数据（置空则用默认的取数据方法）
 *  @param howToSaveData    怎么存储数据（置空则用默认的存储方法。对象则存储为字典）
 *  @param notificationName 抛出的通知名
 */
- (void)url:(NSString *)url method:(NSInteger)method parameters:(NSDictionary *)params needLogin:(BOOL)needLogin fileName:(NSString *)fileName howToGetData:(id (^)(void)) howToGetData howToSaveData:(void (^)(id _Nullable data)) howToSaveData notificationName:( NSString * _Nonnull )notificationName ;


@end
