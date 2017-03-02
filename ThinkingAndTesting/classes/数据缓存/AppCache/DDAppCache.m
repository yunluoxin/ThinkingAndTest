//
//  DDAppCache.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDAppCache.h"
#import "MJExtension.h"
const static CGFloat FileExpiredTimeInterval = 24 * 3600 ;//单位是s

@implementation DDAppCache

+ (NSString *)filePathWithUserName:(NSString *)userName andFileName:(NSString *)fileName
{
    if (!fileName) {
        return nil;
    }
    NSString *path = [self getMainCacheDirectoryPath];
    if (userName) {
        path = [path stringByAppendingFormat:@"/%@/%@.ddAppCache",userName,fileName];
    }else{
        path = [path stringByAppendingFormat:@"/%@.ddAppCache",fileName];
    }
    return path ;
}

+ (NSString *)getMainCacheDirectoryPath
{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    if (!appName) {
//        appName = [infoDictionary objectForKey:@"CFBundleExecutable"];
//    }
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//    path = [path stringByAppendingFormat:@"/%@",appName];
//    return path ;
    
    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier ;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    path = [path stringByAppendingFormat:@"/%@",bundleID];
    return path ;
}

+ (BOOL )isFileExpired:(NSString *)filePath
{
    NSTimeInterval timerInterval = ABS([[[[NSFileManager defaultManager]
                                          
                                          attributesOfItemAtPath:filePath error:nil]
                                         
                                         fileModificationDate] timeIntervalSinceNow]);
    
    if (timerInterval > FileExpiredTimeInterval ||timerInterval == 0) {
        return YES ;
    }else{
        return NO ;
    }
}


+ (id)objectWithFilePath:(NSString *)filePath
{
    if (!filePath) {
        return nil ;
    }
    @try {
        id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        return data ;
    }
    @catch (NSException *exception) {
        DDLog(@"%@",exception);
        return nil ;
    }
    @finally {
        
    }
}

+ (BOOL)saveObject:(id<NSCoding>)obj toFilePath:(NSString *)filePath
{
    if (!filePath) {
        return NO;
    }
    
    NSArray *array = [filePath pathComponents];
    NSMutableArray *arrayM = [array mutableCopy];
    [arrayM removeLastObject];
    NSString *path = [arrayM componentsJoinedByString:@"/"] ;
    @try {
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            BOOL r = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            DDLog(@"%d",r);
        }
        
        BOOL result = [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
        return result ;
    }
    @catch (NSException *exception) {
        DDLog(@"%@",exception);
        return NO ;
    }
    @finally {
        
    }
}

+ (BOOL) saveAnyObject:(id)obj toFilePath:(NSString *)filePath
{
    BOOL result = NO ;
    if (([obj isKindOfClass:[NSValue class]] || [obj isKindOfClass:[NSString class]]) && [obj respondsToSelector:@selector(encodeWithCoder:)]) {
        result = [self saveObject:obj toFilePath:filePath];
    }else{
        result = [self saveObject:[obj mj_JSONObject] toFilePath:filePath];
    }
    return result ;
}

+ (BOOL) deleteFileAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL result ;
    if ([manager fileExistsAtPath:filePath]) {
        @try {
            result = [manager removeItemAtPath:filePath error:nil];
            return result ;
        }
        @catch (NSException *exception) {
            return NO ;
        }
        @finally {
            
        }
    }
    return NO ;
}

+ (void)clearUserCache
{
    
}

+ (float) fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    float size =0;
    
    BOOL isDir;
    
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        return 0 ;
    }
    
    if (!isDir) {
        return [fileManager attributesOfItemAtPath:path error:nil].fileSize/1024.0/1024.0;
    }
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
        
    {
        
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
            
        {
            
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            
            size+= fileAttributeDic.fileSize/1024.0/1024.0;
        }
        
        else
            
        {
            size += [self fileSizeForDir:fullPath];
            
        }
    }
    
    return size;
    
}

@end
