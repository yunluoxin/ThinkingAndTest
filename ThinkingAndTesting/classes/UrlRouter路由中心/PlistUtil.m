//
//  PlistUtil.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "PlistUtil.h"

#import "DDUtils+Security.h"

#import "URConfigInfo.h"

static NSString * SALT_VALUE = @"com.dadong.md5.saltvalue" ;
static NSString * URLRouterFileName = @"UrlRouter.plist" ;
static NSString * const URDownloadPlistConfigFileUrl = @"file:///Users/dadong/Desktop/UrlRouter.plist" ;

static dispatch_semaphore_t semaphore ;

@implementation PlistUtil

+ (void)initialize
{
    semaphore = dispatch_semaphore_create(1) ;
}

+ (NSDictionary *)dictionaryWithFilePath:(NSString *)path
{
    if (path == nil || path.length < 1) return nil ;
    
    return [[NSDictionary alloc] initWithContentsOfFile:path] ;
}

+ (NSDictionary *)chooseConfigsWisely
{
    NSString * cachedFilePath = [self cachedPlistFilePath] ;
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
    
    NSDictionary * cachedDic = [self dictionaryWithFilePath:cachedFilePath] ;
    
    dispatch_semaphore_signal(semaphore) ;
    
    if ([self verfiyDataIsLegalWithOriginalDictionary:cachedDic]) {
        return [self extractConfigsFromLegalOriginalDictionary:cachedDic] ;
    }
    
    NSString * bundleFilePath = [self bundlePlistFilePath] ;
    
    NSDictionary * bunbleDic = [self dictionaryWithFilePath:bundleFilePath] ;
    
    if ([self verfiyDataIsLegalWithOriginalDictionary:bunbleDic]) {
        return [self extractConfigsFromLegalOriginalDictionary:bunbleDic] ;
    }
    
    NSAssert(NO, @"非法访问!") ;
    abort() ;
    return nil ;
}

+ (BOOL)verfiyDataIsLegalWithOriginalDictionary:(NSDictionary *)dic
{
    if (dic == nil || dic.count < 1) return NO ;
    
    NSString * md5Value = dic[@"md5"] ;
    
    if (md5Value == nil || md5Value.length < 16) return NO ;

    NSDictionary * configs = dic[@"configs"] ;
    
    if (configs == nil || configs.count < 1) return NO ;
    
    NSArray * sortedArray = [self sortedArrayWithDictionary:configs] ;
    
    dic = nil ;
    configs = nil ;
    
    NSError * error ;
    NSData * data = [NSJSONSerialization dataWithJSONObject:sortedArray options:NSJSONWritingPrettyPrinted error:&error] ;
    
    if (data && !error) {
        NSString * dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
        NSString * md5Str_1 = [DDUtils encrypt_MD5:dataStr] ;
        NSString * md5Str_2 = [DDUtils encrypt_MD5:[NSString stringWithFormat:@"%@_%@",md5Str_1, SALT_VALUE]] ;
        
        DDLog(@"本地生成的md5值 = > %@",md5Str_2) ;
        
        if ([md5Str_2 isEqualToString:md5Value]) {
            return YES ;
        }
    }
    return NO ;
}


+ (NSDictionary *)extractConfigsFromLegalOriginalDictionary:(NSDictionary *)dic
{
    NSDictionary * c = dic[@"configs"] ;
    NSMutableDictionary * configs = @{}.mutableCopy ;
    
    [c enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSDictionary * obj, BOOL * _Nonnull stop) {
        URConfigInfo * info = [[URConfigInfo alloc] initWithDictionary:obj] ;
        if (info) {
            configs[key] = info ;
        }
    }] ;
    
    return configs.copy ;
}

+ (void)writeDataToCachedPlistFile:(NSDictionary *)originalDic
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
    
    [originalDic writeToFile:[self cachedPlistFilePath] atomically:YES] ;
    
    dispatch_semaphore_signal(semaphore) ;
}

+ (BOOL)removeCachedPlistFile
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
    
    NSError * error ;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:[self cachedPlistFilePath] error:&error] ;
    
    dispatch_semaphore_signal(semaphore) ;
    
    if (result && !error) {
        return YES ;
    }
    return NO ;
}

+ (void)startDownloadingConfigFile
{
    NSURL * url = [NSURL URLWithString:URDownloadPlistConfigFileUrl] ;
    
    NSURLSession * session = [NSURLSession sharedSession] ;
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url] ;

    
    [[session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
            NSDictionary * dic = [[NSDictionary alloc ] initWithContentsOfURL:location] ;
            
            [[NSFileManager defaultManager] removeItemAtURL:location error:nil] ;
            
            if (dic) {
                
                BOOL isLegal = [self verfiyDataIsLegalWithOriginalDictionary:dic] ;
                
                if (isLegal) {
                    [self writeDataToCachedPlistFile:dic] ;
                }else{
                    NSAssert(NO, @"非法数据!!!") ;
                }
                
            }else{
                DDLog(@"序列化出错!") ;
            }
            
        }else{
            /// 出错了。 看能不能 恢复
            DDLog(@"出错了") ;
        }
    }] resume];
}


#pragma mark - private 

+ (NSString *)bundlePlistFilePath
{
    return [[NSBundle mainBundle] pathForResource:URLRouterFileName ofType:nil] ;
}

+ (NSString *)cachedPlistFilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:URLRouterFileName] ;
}


/**
 * !将无序的dictionary对象转换成有序的数组，数组里面每一项，都是 单Entry的 dictionary.
 */
+ (NSArray *)sortedArrayWithDictionary:(NSDictionary *)dic
{
    NSMutableArray * sortedArray = @[].mutableCopy ;
    
    NSArray * keys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2] ;
    }];
    
    for (NSString * key in keys) {
        
        NSDictionary * temp = dic[key] ;
        
        NSArray * temp_keys = [temp.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2] ;
        }];
        
        NSMutableArray *  tempArray = @[].mutableCopy ;
        for (NSString * temp_key in temp_keys) {
            [tempArray addObject:@{temp_key:temp[temp_key]}] ;
        }
        
        [sortedArray addObject:@{key:tempArray}] ;
    }
    
    return sortedArray.copy ;
}

@end
