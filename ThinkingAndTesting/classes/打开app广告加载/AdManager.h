//
//  AdManager.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/13.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdManager : NSObject

/**
 *  检查本地是否存在广告图片
 *
 *  @return 存在返回YES，不存在返回NO
 */
+ (BOOL)isExistAdImageInLocal;

/**
 *  返回广告图片的路径
 *
 *  @return 图片路径
 */
+ (NSString *)getAdImagePath;

/**
 *  从网络加载图片
 */
+ (void)loadAdImageFromNet;

/**
 *  下载指定url地址的图片
 *
 *  @param imageUrl 图片地址
 */
+ (void)downloadImage:(NSString *)imageUrl ;

/**
 *  自动处理广告，如果有广告，自动进入广告控制器，并返回YES，如果没广告，自动在后台下载广告，并返回NO，  返回NO的时候需要自己指定当前的rootVC
 *
 *  @return
 */
+ (BOOL)handleAD ;

@end
