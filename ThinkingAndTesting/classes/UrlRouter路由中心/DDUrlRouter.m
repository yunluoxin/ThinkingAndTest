//
//  DDUrlRouter.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDUrlRouter.h"

#import "URConfigInfo.h"
#import "PlistUtil.h"

#import "URAppVersionTooLow_ViewController.h"
#import "URWrongPage_ViewController.h"
#import "URWebViewController.h"

@interface DDUrlRouter ()

/**
 用dictionary存储，而不用数组的原因是，查询效率会更高，不用一个个便利，直接用key找
 */
@property (nonatomic, readonly, strong)NSDictionary<NSString *, URConfigInfo *> *configs ;

@end

@implementation DDUrlRouter

+ (instancetype)sharedRouter
{
    static id router = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init] ;
        [router setupParams] ;
    });
    return router ;
}

- (void)setupParams
{   
    _configs = [PlistUtil chooseConfigsWisely] ;
}


#pragma mark - 网页访问的入口

+ (UIViewController *)viewControllerWithUrlFromWeb:(NSString *)urlStr
{
    /// 这些返回nil的， 也可以统一返回到一个错误页面
    if (!urlStr) return nil ;
    
    NSString * prefix1 = @"http://www.kachemama.com/mobile/" ;
    NSString * prefix2 = @"https://www.kachemama.com/mobile/" ;
    NSString * prefix  = nil ;
    
    if ([urlStr hasPrefix:prefix1]) {
        prefix = prefix1 ;
    }else if([urlStr  hasPrefix:prefix2]){
        prefix = prefix2 ;
    }else{
        return nil ;
    }
    
    NSString * urlStrWithoutPrefix = [urlStr stringByReplacingOccurrencesOfString:prefix withString:@""] ;
    
    NSUInteger index = [urlStrWithoutPrefix rangeOfString:@"?"].location ;
    
    NSString * key = index == NSNotFound ? urlStrWithoutPrefix : [urlStrWithoutPrefix substringToIndex:index] ;
    
     NSURL * url = [NSURL URLWithString:urlStr] ;
    
    NSDictionary *paramDic = [self.class convertParamsToMap:url.query] ;
    
    return [[self sharedRouter] p_viewControllerWithKey:key params:paramDic orginalUrl:urlStr sourceWeb:YES] ;
}


#pragma mark - 本地跳转的入口

+ (UIViewController *)viewControllerWithUrlFromNative:(NSString *)urlStr
{
    return [self viewControllerWithUrlFromNative:urlStr params:nil] ;
}

+ (UIViewController *)viewControllerWithUrlFromNative:(NSString *)urlStr params:(NSDictionary *)params
{
    NSURL * url = [NSURL URLWithString:urlStr] ;
    
    NSUInteger index = [urlStr rangeOfString:@"?"].location ;
    
    NSString * key = index == NSNotFound ? urlStr : [urlStr substringToIndex:index] ;
    
    NSMutableDictionary *paramDic = [self.class convertParamsToMap:url.query].mutableCopy ;
    
    if (params) {
        [paramDic setValuesForKeysWithDictionary:params] ;
    }
    
    return [[self sharedRouter] p_viewControllerWithKey:key params:paramDic orginalUrl:urlStr sourceWeb:NO] ;
}

#pragma mark - ultimate

- (UIViewController *)p_viewControllerWithKey:(URPagePathKey)pathKey
                                       params:(NSDictionary *)params
                                   orginalUrl:(NSString *)originalUrl
                                    sourceWeb:(BOOL)fromWeb
{
    if (!pathKey || pathKey.length < 1) return nil ;
    
    URConfigInfo * info = self.configs[pathKey] ;
    
    if (info)
    {
        // 1. 比对版本
        NSString * minVersion = info.minVersion ;
        
        if (minVersion) {
            NSString * currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] ;
            if ([currentVersion floatValue] < [minVersion floatValue]) {
                /// 版本太低，跳转提示版本太低，要升级的页面
                return [URAppVersionTooLow_ViewController new] ;
            }
        }
        
        
        // 2. 是否需要登录
        BOOL needLogin = info.loginNeed ;
        
        if (needLogin) {
            
            /// 检测当前是否登录
            
        }
        
        
        
        // 3. 是否禁止从web访问
        BOOL forbidSourceWeb = info.forbidSourceWeb ;
        
        if (forbidSourceWeb && fromWeb) {
            /// 拒绝web访问，但是也提示错误页面，可修改
            return [URWrongPage_ViewController new] ;
        }
        
        
        
        // 4. 找页面
        NSString * vcName = info.vcName ;
        if (vcName) {
            
            Class vc = NSClassFromString(vcName) ;
            
            if (vc) {   /// 能够在当前app找到VC
                
                UIViewController * newVC = [vc new] ;
                
                NSAssert([newVC isKindOfClass:[UIViewController class]], @"Not a legal viewController object") ;
                
                /// 给vc注入参数值
                if (params) [self.class injectPropertyValues:params toObject:newVC] ;
                
                return newVC ;
            }
        }
        
        /// 找不到此vc，采用降级方案，找H5
        NSString * h5PageUrl = info.h5PageUrl ;
        
        if (h5PageUrl) {
            /// 加载H5页面, 返回一个webView包装的页面
            URWebViewController * webVC = [URWebViewController new] ;
            webVC.h5PageUrl = h5PageUrl ;
            return webVC ;
        }
        else    /// h5PageUrl值不存在
        {
            return [URWrongPage_ViewController new] ;   /// 跳错误页面
        }

        
    }
    else    /// 配置信息不存在。可能是一个错误的url. 方案有两种，一种是直接加载url，一种是直接报错了。
    {
        if (fromWeb) {
            URWebViewController * webVC = [URWebViewController new] ;
            webVC.normalWebUrl = originalUrl ;
            return webVC ;
        }
        
        NSString * wrongMsg = [NSString stringWithFormat:@"当前提供的本地key=> %@ , 没有找到相应的配置文件，请检测下", pathKey] ;
        NSAssert(NO, wrongMsg) ;
        
        return nil ;
    }
    
    return nil ;
}


#pragma mark - util method
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

+ (void)injectPropertyValues:(NSDictionary *)params toObject:(id)object
{
    for (NSString * propertyName in params) {
        SEL getter = NSSelectorFromString(propertyName) ;
        if ([object respondsToSelector:setterForGetter(getter)]) {
            [object setValue:params[propertyName] forKey:propertyName] ;
        }
    }
}

static SEL setterForGetter(SEL getter)
{
    NSString * firstChar = [[@(sel_getName(getter)) substringToIndex:1] uppercaseString] ;
    NSString * setterStr = [NSString stringWithFormat:@"set%@%@:",firstChar,[@(sel_getName(getter)) substringFromIndex:1]] ;
    return NSSelectorFromString(setterStr) ;
}

@end
