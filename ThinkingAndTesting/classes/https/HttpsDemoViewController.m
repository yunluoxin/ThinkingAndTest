//
//  HttpsDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "HttpsDemoViewController.h"

#import "AFNetworking.h"

@interface HttpsDemoViewController ()< NSURLConnectionDelegate, NSURLSessionDataDelegate>

@end

@implementation HttpsDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 移除所有的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses] ;
    
//    [self test1] ;
    
//    [self testSession] ;
    
//    [self testSharedSession] ;

//    [self testAFNetworkingHttps];
    
    [self testSessionNoDelegate];
}


///
/// 测试AFN的SSL证书校验
///
/// 即使已经把AFSecurityPolicy设置成默认的证书校验方式，并且设置allowInvalidCertificates = YES，validatesDomainName = NO. AFNetwoking可以通过，
/// 但是内部调用ServerTrust构造Credential交给System内部还是失败的！！！（如果把info.plist里面的Allow Arbitary Load开启，则是成功的！也说明了，info.plist里面那个就是控制这个的！）
///
///
- (void)testAFNetworkingHttps {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    manager.securityPolicy = policy;
    [manager GET:@"https://www.12306.cn/mormhweb/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

///
/// 即使已经设置 Allow Arbitary Load = YES, 这个请求还是失败了！（12306是自证书）
/// @conclusion: 【session dataTaskWithRequest:request completionHandler:】内部可能加了其他的校验！（不止是secTrust校验）
///
- (void)testSessionNoDelegate {
    NSURL * url = [NSURL URLWithString:@"https://www.12306.cn/mormhweb/"] ;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url] ;
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"%@",response);
        }else{
            NSLog(@"%@",error);
        }
    }] ;
    
    [task resume] ;
}


/**
 自己实现鉴权挑战的
 */
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
//  sharedSession就是apple提供的default会话！！！ [NSURLProtocol registerClass:xxx] 注册的，只能影响到默认的会话，就是这个会话。其他自己创建的会话，要另外写!
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



#pragma mark - NSURLSessionDelegate

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
