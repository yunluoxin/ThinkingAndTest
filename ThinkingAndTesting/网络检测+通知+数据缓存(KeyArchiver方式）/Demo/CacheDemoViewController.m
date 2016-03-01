//
//  CacheDemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CacheDemoViewController.h"
#import <WebKit/WebKit.h>
#import "CacheDemoModel.h"
@interface CacheDemoViewController ()
{
    CacheDemoModel *_model ;
    WKWebView *_webView;
}
@end

@implementation CacheDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc]init];
//    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:conf];
//    _webView = webView ;
//    [self.view addSubview:webView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(dd:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 30, 30);
    [self.view addSubview:button];
    
    
    _model = [[CacheDemoModel alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(abc:) name:@"abc" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dd:(UIButton *)button
{
    [_model getSomethingById:nil];
//    [CacheDemoModel getSomethingById:nil];
}
- (void)abc:(NSNotification *)note
{
    NetworkDataStatus status = ((NSNumber *)note.userInfo[@"status"]).intValue;
    switch (status) {
        case NetworkDataStatusHasNetworkHasData:
        {
//            DDLog(@"%@",note.userInfo[@"data"]);
            
            break;
        }
        case NetworkDataStatusNoNetworkHasData:
        {
            DDLog(@"%@",note.userInfo[@"data"]);
            
            break;
        }
        case NetworkDataStatusHasNetworkNoData:
        {
            DDLog(@"出错了");
            break;
        }
        case NetworkDataStatusNoNetworkNoData:
        {
            DDLog(@"无网络");
            break;
        }
    }
    
}
@end
