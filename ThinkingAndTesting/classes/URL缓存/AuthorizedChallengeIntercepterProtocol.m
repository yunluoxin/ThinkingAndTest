//
//  AuthorizedChallengeIntercepterProtocol.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

///========================================================================================================================================================
///  带来了一个问题，就是第二次再发送相同的请求时候，又进行了鉴权验证！而原来是可以缓存的(验证过的host, 一般不会再次请求验证)！ 那现在是要自己实现？还是由哪里修改设置。
///
///  1. 初步缓存后，带来了速度大幅度提升，也可能是创建新的session带来的。 后续理解了NSURLSession后再来回答。
///  2. 有了host缓存，是否有必要再标记已经处理的url呢？
///
///========================================================================================================================================================



#import "AuthorizedChallengeIntercepterProtocol.h"
#import "DDSecurityHandler.h"

static NSString *const DDAuthorizedChallengeIntercepterHandledKey = @"DDAuthorizedChallengeIntercepterHandledKey" ;

static NSMutableDictionary * authenticatiedHosts ; // 已经获得验证的host，内部维护的一个列表，以防多次验证同一个host，浪费时间

@interface AuthorizedChallengeIntercepterProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession * session ;

@end

@implementation AuthorizedChallengeIntercepterProtocol

+ (void)initialize
{
    authenticatiedHosts = @{}.mutableCopy ;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    BOOL handled = [self propertyForKey:DDAuthorizedChallengeIntercepterHandledKey inRequest:request] ;
    
    if (handled)    return NO ;
    
    BOOL isHttps = [request.URL.scheme isEqualToString:@"https"] ;
    
    // if not https request, don't handle.
    if (!isHttps)   return NO ;
    
    // has authenticated this url's host?
    BOOL authenticated = authenticatiedHosts[request.URL.host] ;
    
    return !authenticated ;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request ;
}

- (void)startLoading
{
    NSMutableURLRequest * request = self.request.mutableCopy ;
    
    // mark flag to have handled.
    [[self class] setProperty:@(YES) forKey:DDAuthorizedChallengeIntercepterHandledKey inRequest:request] ;
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]] ;
    
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request] ;
    
    [task resume] ;
}

- (void)stopLoading
{
    DDLog(@"%s",__func__) ;
    
    [self.session invalidateAndCancel] ;
    
    self.session = nil ;
    
    [[self class] removePropertyForKey:DDAuthorizedChallengeIntercepterHandledKey inRequest:self.request] ;
}



#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    DDLog(@"%s",__func__) ;
    
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response] ;
    
    completionHandler(request) ;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    DDLog(@"%s, %@",__func__, error) ;
    
    if (error) {
        [self.client URLProtocol:self didFailWithError:error] ;
    }else{
        [self.client URLProtocolDidFinishLoading:self] ;
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    DDLog(@"%s",__func__) ;
    
    [self.client URLProtocol:self didLoadData:data] ;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    DDLog(@"%s",__func__) ;
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed] ;
    
    completionHandler(NSURLSessionResponseAllow) ;
}


//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
//{
//    
//}

#pragma mark - authenticateion challenge

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    DDLog(@"%s",__func__) ;
    
    if ([DDSecurityHandler vaildateChallenge:challenge]) {
        NSURLCredential * credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] ;
        
        [authenticatiedHosts setObject:@(YES) forKey:task.currentRequest.URL.host] ;
        
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential) ;
        
//        [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge] ;
    }else{
        
//        [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge] ;
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil) ;
    }
}

@end
