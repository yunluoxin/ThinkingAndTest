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
    
    dic = nil ;
    
    NSError * error ;
    NSData * data = [NSJSONSerialization dataWithJSONObject:configs options:NSJSONWritingPrettyPrinted error:&error] ;
    
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

#pragma mark - private 

+ (NSString *)bundlePlistFilePath
{
    return [[NSBundle mainBundle] pathForResource:URLRouterFileName ofType:nil] ;
}

+ (NSString *)cachedPlistFilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:URLRouterFileName] ;
}

@end
