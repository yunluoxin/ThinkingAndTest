//
//  DDAppCache.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAppCache : NSObject
/**
 *  获得当前设置的主缓存存储路径 ---> xxx/Caches/当前的appName/
 *
 *  @return 目录路径
 */
+ (NSString *) getMainCacheDirectoryPath ;

/**
 *  根据用户名和文件名生成一个文件路径
 *
 *  @param userName 用户名（可空，若为空，则取数据时候也一定置空）
 *  @param fileName 文件名
 *
 *  @return 一个文件路径
 */
+ (NSString *)filePathWithUserName:(NSString *)userName andFileName:(NSString *)fileName ;


/**
 *  获取指定路径处的数据
 *
 *  @param filePath 指定路径
 *
 *  @return 一个存储在路径中的对象
 */
+ (id)objectWithFilePath:(NSString *)filePath;


/**
 *  存储遵循NSCoding的对象到指定的路径
 *
 *  @param obj      对象(必须实现 NSCoding 协议）
 *  @param filePath 指定的路径
 *
 *  @return 是否保存成功
 */
+ (BOOL)saveObject:(id<NSCoding>)obj toFilePath:(NSString *)filePath;

/**
 *  存储任意对象到指定的路径，（如果是没有实现NSCoding协议的对象，则自动转成成字典保存，使用时候要注意）
 *
 *  @param obj      对象
 *  @param filePath 指定的路径
 *
 *  @return 是否保存成功
 */
+ (BOOL) saveAnyObject:(id)obj toFilePath:(NSString *)filePath;

/**
 *  删除指定路径处的文件
 *
 *  @param filePath 文件路径
 *
 *  @return 是否删除成功
 */
+ (BOOL) deleteFileAtPath:(NSString *)filePath ;

/**
 *  判断文件是否过期 （只判断是否过期，不判断文件是否存在）
 *
 *  @param filePath 文件名
 *
 *  @return 文件是否过期
 */
+ (BOOL )isFileExpired:(NSString *)filePath ;

/**
 *  计算文件或者文件夹下所有文件的总大小（单位是MB）
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
+ (float) fileSizeForDir:(NSString*)path ;
@end
