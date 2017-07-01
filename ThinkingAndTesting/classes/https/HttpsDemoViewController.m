//
//  HttpsDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "HttpsDemoViewController.h"

@interface HttpsDemoViewController ()< NSURLConnectionDelegate, NSURLSessionDataDelegate>

@end

@implementation HttpsDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 移除所有的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses] ;
    
//    [self test1] ;
    
//    [self testSession] ;
    
    [self testSharedSession] ;


}

- (void)testSession
{
//    NSURL * url = [NSURL URLWithString:@"https://image.kachemama.com/products/131100FG001/detail/131100FG001_1.jpg"] ;
//    NSURL * url = [NSURL URLWithString:@"https://www.qcloud.com/?utm_source=bdppzq&utm_medium=line&utm_campaign=baidu"] ;
    NSURL * url = [NSURL URLWithString:@"https://www.12306.cn/mormhweb/"] ;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url] ;
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]] ;
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request] ;
    
    [task resume] ;
}

//
//  发现一个问题，sharedSession创建的就是默认的会话！没有设置代理的地方，默认就是block回调！所以要简单处理数据，不需要代理的时候，可以直接用sharedSession
//  sharedSession就是apple提的default会话！！！ [NSURLProtocol registerClass:xxx] 注册的，只能影响到默认的会话，就是这个会话。其他自己创建的会话，要另外写!
//
- (void)testSharedSession
{
    NSURL * url = [NSURL URLWithString:@"https://image.kachemama.com/products/131100FG001/detail/131100FG001_1.jpg"] ;
    //    NSURL * url = [NSURL URLWithString:@"https://www.qcloud.com/?utm_source=bdppzq&utm_medium=line&utm_campaign=baidu"] ;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url] ;
    NSURLSession * session =  [NSURLSession sharedSession] ;
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }] ;
    [dataTask resume] ;
}

- (void)test1
{
    
//        NSURL * url = [NSURL URLWithString:@"https://api.m.kachemama.com/mobile/home/data"] ;
    NSURL * url = [NSURL URLWithString:@"https://www.qcloud.com/?utm_source=bdppzq&utm_medium=line&utm_campaign=baidu"] ;
    
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url] ;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError){
        
        if (connectionError) {
            NSLog(@"%@",connectionError) ;
            return  ;
        }
        
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        
        DDLog(@"%@",str) ;
        
    }] ;
    
    [NSURLConnection connectionWithRequest:request delegate:self] ;
}



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
    {
        
        NSArray * paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"cer" inDirectory:nil] ;
        
        NSMutableArray * certs = @[].mutableCopy ;
        
        for (NSString * path in paths)
        {
            NSData * data = [[NSData alloc] initWithContentsOfFile:path] ;
            
            SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)data) ;
            
            [certs addObject:(__bridge_transfer id)cert ] ;
            
//            CFRelease(cert) ;
        }
        
        SecTrustRef trustRef = challenge.protectionSpace.serverTrust ;
        
        //设置根证书
        SecTrustSetAnchorCertificates(trustRef, (__bridge CFArrayRef)certs ) ;
        SecTrustSetAnchorCertificatesOnly(trustRef, NO) ;
        
        SecTrustResultType result ;
        OSStatus status = SecTrustEvaluate(trustRef, &result) ;
        
        if (status == errSecSuccess)
        {
            DDLog(@"校验完成") ;
            
            if (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)
            {
                DDLog(@"号了") ;
                
                NSURLCredential * credential = [NSURLCredential credentialForTrust:trustRef] ;
                completionHandler(NSURLSessionAuthChallengeUseCredential, credential) ;
                return ;
            }
        }
        
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil) ;
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error) ;
        return  ;
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
    DDLog(@"%@",str) ;
}

@end
