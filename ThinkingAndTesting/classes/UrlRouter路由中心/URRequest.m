//
//  URRequest.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/28.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "URRequest.h"

@interface URRequest ()
{
    NSURL           * _URL ;
    NSString        * _fullPath ;
    NSMutableDictionary    * _params ;
}

@end

@implementation URRequest

#pragma mark - design init method

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"NSForbiddenInitMethodException" reason:@"please use `- initWithUrl:withType:` or `+ requestWithUrl:withType:` instead." userInfo:nil] ;
    return nil ;
}

- (instancetype)initWithUrl:(NSString *)originalUrl withType:(URRequestType)type
{
    NSAssert(originalUrl && originalUrl.length > 0, @"url不能为空") ;
    if (self = [super init]) {
        _originalUrl = originalUrl.copy ;
        _requestType = type ;
    }
    return self ;
}

+ (instancetype)requestWithUrl:(NSString *)originalUrl withType:(URRequestType)type
{
    return [[self alloc] initWithUrl:originalUrl withType:type] ;
}

#pragma mark - getter and setter

- (NSURL *)URL
{
    if (!_URL) {
        _URL = [NSURL URLWithString:self.originalUrl] ;
    }
    return _URL ;
}

- (NSString *)scheme
{
    return self.URL.scheme ;
}

- (NSString *)host
{
    return self.URL.host ;
}

- (NSString *)path
{
    return self.URL.path ;
}

- (NSString *)fullPath
{
    if (!_fullPath) {
        _fullPath = [self.host stringByAppendingPathComponent:self.path] ;
    }
    return _fullPath ;
}

- (NSDictionary *)params
{
    if (!_params) {
        _params = [self.class convertParamsToMap:self.URL.query].mutableCopy ;
    }
    return _params.copy ;
}


/**
 将参数串转换成map
 @param params 参数串，如a=b&c=d&e=f
 @return 字典
 */
+ (NSDictionary *)convertParamsToMap:(NSString *)params
{
    if (params == nil) {
        return @{} ;
    }
    
    NSMutableDictionary * dicM = @{}.mutableCopy ;
    NSArray * array = [params componentsSeparatedByString:@"&"] ;
    for (NSString * entry in array) {
        NSArray * temp = [entry componentsSeparatedByString:@"="] ;
        if (temp.count < 2) {
            continue ;
        }
        dicM[temp[0]] = temp[1] ;
    }
    
    return dicM.copy ;
}

@end
