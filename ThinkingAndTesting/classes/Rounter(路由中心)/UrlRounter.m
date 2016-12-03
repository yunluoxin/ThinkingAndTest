//
//  UrlRounter.m
//  kachemama
//
//  Created by dadong on 16/12/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "UrlRounter.h"
#import "DD_WrongPage_ViewController.h"
#import "DD_WebView_Controller.h"
#import "DD_GoodsDetail_ViewController.h"

NSString * const kUrlRounterScheme =    @"kachemama"   ;
NSString * const kUrlHostActivity  =    @"act"         ;
NSString * const kUrlHostDetail    =    @"detail"      ;

@implementation UrlRounter

+ (void)openUrl:(NSString *)urlString
{
    if (!urlString) {
        return ;
    }
    
    NSURL * url = [NSURL URLWithString:urlString] ;
    NSString * scheme = url.scheme ;
    NSString * host = url.host ;
    NSString * params = url.parameterString ;
    
    if ([kUrlRounterScheme isEqualToString:scheme]) {

        if ([kUrlHostDetail isEqualToString:host]) {
            NSDictionary * dic = [self convertParamsToMap:params] ;
            DD_GoodsDetail_ViewController * vc = [DD_GoodsDetail_ViewController new] ;
            vc.goodsInfoModel.goods_sn = dic[@"goodsSn"] ;
            [self dd_showViewController:vc] ;
            return ;
        }
        
        
        if ([kUrlHostActivity isEqualToString:host]) {
            NSString * pageUrl = [NSString stringWithFormat:@"%@%@?%@",configUrl,host,params] ;
            DD_WebView_Controller * vc = [DD_WebView_Controller new] ;
            vc.link = pageUrl ;
            vc.title = @"会场" ;
            [self dd_showViewController:vc] ;
            return ;
        }
        
    }
    
    //错误的page
    DD_WrongPage_ViewController * vc = [DD_WrongPage_ViewController new] ;
    [self dd_showViewController:vc] ;
    return ;
}


+ (void)dd_showViewController:(UIViewController *)viewController
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController ;
    if (rootVC.presentedViewController) {
        UIViewController * temp = rootVC.presentedViewController ;
        if ([temp isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)temp ;
            [nav pushViewController:viewController animated:YES] ;
        }else{
            [temp presentViewController:viewController animated:YES completion:nil] ;
        }
    }else{
        UINavigationController * nav ;
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabVC = (UITabBarController *)rootVC ;
            rootVC = tabVC.selectedViewController ;
        }
        
        if ([rootVC isKindOfClass:[UINavigationController class]]){
            nav = (UINavigationController *)rootVC ;
        }
        
        if (nav) {
            [nav pushViewController:viewController animated:YES] ;
        }else{
            [rootVC presentViewController:viewController animated:YES completion:nil] ;
        }
    }
}


/**
    将参数串转换成map
    @param params 参数串，如a=b&c=d&e=f
    @return 字典
 */
+ (NSDictionary *)convertParamsToMap:(NSString *)params
{
    if (params == nil) {
        return nil ;
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
