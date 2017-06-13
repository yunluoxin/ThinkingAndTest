//
//  SimplifyURLProtocol.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "SimplifyURLProtocol.h"
#import "DDSecurityHandler.h"

static NSString * const SimplifyURLProtocolKey = @"SimplifyURLProtocolKey" ;

@interface SimplifyURLProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession * session ;

@end

@implementation SimplifyURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    BOOL handled = [self propertyForKey:SimplifyURLProtocolKey inRequest:request] ;
    
    if (handled)    return NO ;
    
    BOOL isHttps = [request.URL.scheme isEqualToString:@"https"] ;
    
    // if not https request, don't handle.
    if (!isHttps)   return NO ;
    
    
    return YES ;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request ;
}

- (void)startLoading
{
    NSMutableURLRequest * request = self.request.mutableCopy ;
    
    // mark flag to have handled.
    [[self class] setProperty:@(YES) forKey:SimplifyURLProtocolKey inRequest:request] ;
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]] ;
    
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request] ;
    
    [task resume] ;
}

- (void)stopLoading
{
    DDLog(@"%s",__func__) ;
    
    [self.session invalidateAndCancel] ;
    
    self.session = nil ;
    
    [[self class] removePropertyForKey:SimplifyURLProtocolKey inRequest:self.request] ;
}


#pragma mark - authenticateion challenge

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    DDLog(@"%s",__func__) ;
    
    if ([DDSecurityHandler vaildateChallenge:challenge]) {
        NSURLCredential * credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] ;
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential) ;
        
#pragma mark - @attention
        //
        //  发现这一句有没有写，决定其他地方的网络请求代理接受不到challenge的回调！！！
        //
        //        [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge] ;
    }else{
        
        [self.client URLProtocol:self didCancelAuthenticationChallenge:challenge] ;
        
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil) ;
    }
}



@end
