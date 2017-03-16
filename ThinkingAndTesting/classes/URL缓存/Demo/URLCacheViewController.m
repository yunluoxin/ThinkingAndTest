//
//  URLCacheViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "URLCacheViewController.h"
#import "AFNetworking.h"
#import "DDAppCache.h"

//#define SCREEN_WIDTH  ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait? ([UIScreen mainScreen].bounds.size.width):([UIScreen mainScreen].bounds.size.height))

@interface URLCacheViewController ()<UIWebViewDelegate>
{
    UIWebView * _webView ;
}
@end

@implementation URLCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger statusCode = 404 ;
    BOOL      cacheable  = NO  ;
    
    switch (statusCode) {
        case 200:
        case 203:
        case 206:
        case 301:
        case 304:
        case 404:
        case 410:
        {
            cacheable = YES;
            break;
        }
        default: {
            cacheable = NO;
        } break;
    }
    DDLog(@"cacheable: %i",cacheable) ;
    
    
    NSString * url = @"http://api.m.kachemama.com/mobile/home/data" ;
//    NSString * url = @"https://www.baidu.com" ;
//    NSString * url = @"http://debugger.m.kachemama.com/" ;
    
    
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds] ;
    [self.view addSubview:webView] ;
    _webView = webView ;
    webView.delegate = self ;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] ];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:185.0/255.0 green:220.0/255.0 blue:47.0/255.0 alpha:1.0] ;
    button.frame = CGRectMake(100, 100, 100, 30);
    [button addTarget:self action:@selector(loadNetWork) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    button2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] ;
    button2.frame = CGRectMake(100, 200, 100, 30);
    [self.view addSubview:button2];
    
}


// send normal request, just as often.
- (void)sendNormalRequest
{
    NSString * url = @"http://api.m.kachemama.com/mobile/home/data" ;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] ];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        DDLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding])
    }] ;

    return ;
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES ;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DDLog(@"\n\n\n结束加载\n\n\n" );
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLog(@"\n\n\n webView发生错误!!! \n\n\n" );
}


- (void)loadNetWork
{
    [_webView reload] ;
    
//    NSString *str = @"http://localhost:8182/mobile/home/category;jsessionId=?token=null&dafd=323" ;
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedInstance ];
//    [manager POST:str parameters:@{@"key":@"value"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            DDLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
//    [manager GET:str parameters:@{@"key":@"value"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DDLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

//    DDLog(@"%f",DD_SCREEN_WIDTH);
}
@end
