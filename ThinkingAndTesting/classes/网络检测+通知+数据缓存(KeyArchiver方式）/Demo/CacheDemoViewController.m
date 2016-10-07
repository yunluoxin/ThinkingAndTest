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
    NetworkDataStatus status = ((NSNumber *)note.userInfo[@"NetworkDataStatus"]).intValue;
    switch (status) {
        case NetworkDataStatusHasNetworkHasData:
        {
            //正常状态，该干什么干什么。 记得判断status
            DDLog(@"%@",note.userInfo[@"data"]);
            
            break;
        }
            
        case NetworkDataStatusHasNetworkNoData:
        {
            //出错了哦。不是说获取的列表数据数组为空。
            DDLog(@"出错了");
            break;
        }
            
        case NetworkDataStatusNoNetworkHasData:
        {
            //没网络，但是读取到了本地的数据。该干嘛还是干嘛。不用提示 当前无网络，全局发出
            DDLog(@"%@",note.userInfo[@"data"]);
            
            break;
        }
        
        case NetworkDataStatusNoNetworkNoData:
        {
            //无网络也无数据。全局会发出 当前无网络。你可以做一些其他的处理。
            DDLog(@"无网络");
            break;
        }
    }
    
}
@end
