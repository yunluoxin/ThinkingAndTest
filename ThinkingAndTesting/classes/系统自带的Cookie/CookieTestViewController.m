//
//  CookieTestViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CookieTestViewController.h"
#import "AFHTTPSessionManager.h"
@interface CookieTestViewController ()


@end

@implementation CookieTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * account = @"15359518185" ;
    NSString * password = @"123456" ;
    
    NSString * url = @"http://m-dev.kachemama.com/mobile/partner/signin" ;
    AFHTTPSessionManager *  m = [AFHTTPSessionManager manager] ;
    NSDictionary *dic = @{
                          @"username":account,
                          @"password":password
                          };
    
    
    NSHTTPCookie * cookie = [[NSHTTPCookie alloc] initWithProperties:@{
                                                                       NSHTTPCookieName :@"JSESSIONID",
                                                                       NSHTTPCookieValue:@"942DA082695903C5E04DFD90895D9E2C",
                                                                       NSHTTPCookieDomain:@"m-dev.kachemama.com",
                                                                       NSHTTPCookiePath:@"/",
//                                                                       NSHTTPCookieDiscard:@"FALSE",
                                                                       NSHTTPCookieMaximumAge:@"100",
                                                                       NSHTTPCookieVersion:@"1"
                                                                       }] ;
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie] ;
    
    DDLog(@"%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
    
//    [m POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLog(@"%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
//        DDLog(@"%@",responseObject) ;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }] ;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString * url = @"http://m-dev.kachemama.com/mobile/cart/list" ;
    AFHTTPSessionManager *  m = [AFHTTPSessionManager manager] ;
    
    [m POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLog(@"%@",[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
        DDLog(@"%@",responseObject) ;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLog(@"%@",error.localizedDescription) ;
    }] ;
}

@end
