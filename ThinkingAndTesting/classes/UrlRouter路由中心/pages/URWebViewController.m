//
//  URWebViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "URWebViewController.h"

@interface URWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView ;

//当前页面的网址host信息，类似微信的网页标明此页提供商
@property (nonatomic, strong)UILabel   * providedLabel ;

/**
 跳转的原始url，内置的用来注入属性的
 */
@property (nonatomic, copy) NSString * dd_originUrl ;
@end

@implementation URWebViewController

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self ;
}

- (void)dealloc
{
    [_webView stopLoading] ;
    _webView = nil ;
    NSLog(@"%s",__func__) ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    self.navigationItem.title = @"loading..." ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.h5PageUrl?:self.normalWebUrl]] ;
    
    [self.webView loadRequest:urlRequest] ;
    
    [self setupLeftItem] ;
}

- (void)setupLeftItem
{
    self.navigationItem.hidesBackButton = YES ;

    UIImage * image = [UIImage imageNamed:@"back"] ;
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)] ;
    [backButton setBackgroundImage:image forState:UIControlStateNormal] ;
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside] ;
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    UIImage * image2 = [UIImage imageNamed:@"back"] ;
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image2.size.width, image2.size.height)] ;
    [closeButton setBackgroundImage:image forState:UIControlStateNormal] ;
    [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside] ;
    UIBarButtonItem * closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton] ;
    
    self.navigationItem.leftBarButtonItems = @[backItem, closeItem] ;
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] ;
    
    self.providedLabel.text = [NSString stringWithFormat:@"Provided by %@",webView.request.URL.host] ;
}

#pragma mark - actions
- (void)back:(id)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;
    }
}

- (void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)didReceiveMemoryWarning
{
    self.webView = nil ;
    
    [super didReceiveMemoryWarning] ;
}

#pragma mark - private methods

#pragma mark - getter and setter 

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds] ;
        _webView.delegate = self ;
        CGFloat top = self.navigationController.isNavigationBarHidden ? 0 : 64.0f ;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0 );
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset ;
        _webView.backgroundColor = HexColor(0x111) ;
        
        [_webView insertSubview:self.providedLabel atIndex:0] ;
        
        [self.view addSubview:_webView] ;
    }
    return _webView ;
}

- (UILabel *)providedLabel
{
    if (!_providedLabel) {
        CGFloat height = 30.0f ;
        CGFloat y = self.navigationController.isNavigationBarHidden ? 0 : 64.0f ;
        _providedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y , self.view.bounds.size.width, height)] ;
        _providedLabel.textAlignment = NSTextAlignmentCenter ;
        _providedLabel.textColor = [UIColor whiteColor] ;
        _providedLabel.font = [UIFont systemFontOfSize:11] ;
    }
    return _providedLabel ;
}
@end
