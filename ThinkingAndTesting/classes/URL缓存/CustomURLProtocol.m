//
//  CustomURLProtocol.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/15.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CustomURLProtocol.h"

static NSString * const CustomeURLProtocolHasHandledKey = @"CustomeURLProtocolHasHandledKey" ;

@interface CustomURLProtocol ()<NSURLConnectionDataDelegate>

/**
 *  <#note#>
 */
@property (nonatomic, strong)NSURLConnection * connection ;

@end

@implementation CustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    BOOL result = [self propertyForKey:CustomeURLProtocolHasHandledKey inRequest:request] ;
    
    DDLog(@"%s\n %@ --- result : %@, %@",__func__, request.URL.absoluteString, result?@"YES":@"NO", request) ;
    
    return !result ;
}

//+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
//{
//    BOOL result = [self propertyForKey:CustomeURLProtocolHasHandledKey inRequest:task.currentRequest] ;
//
//    DDLog(@"%s\n %@ --- result : %@",__func__, task.currentRequest.URL.absoluteString, result?@"YES":@"NO") ;
//    
//    return !result ;
//}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    DDLog(@"%s",__func__) ;
//    NSMutableURLRequest * newRequest = request.mutableCopy ;
//    newRequest.URL = [NSURL URLWithString:@"https://www.baidu.com"] ;
//    return newRequest ;
    return request ;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    DDLog(@"%s",__func__) ;
    
    return [super requestIsCacheEquivalent:a toRequest:b] ;
}

- (void)startLoading
{
    DDLog(@"%s",__func__) ;
    NSMutableURLRequest * request = self.request.mutableCopy ;

    
    // modify url
    NSURL * url = [NSURL URLWithString:@"http://debugger.m.kachemama.com/"] ;
    request.URL = url ;
    
    [CustomURLProtocol setProperty:@(YES) forKey:CustomeURLProtocolHasHandledKey inRequest:request] ;
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self] ;
}

- (void)startLoading1
{
    DDLog(@"%s, %@, %@",__func__, self, self.request) ;
    
    NSMutableURLRequest * request = [self.request mutableCopy] ;
    
    DDLog(@"-==================test--=======================") ;
    [CustomURLProtocol setProperty:@(YES) forKey:CustomeURLProtocolHasHandledKey inRequest:request] ;
    NSNumber * result = [CustomURLProtocol propertyForKey:CustomeURLProtocolHasHandledKey inRequest:request] ;
    DDLog(@"result-bool--->%@, %@",result, request) ;
    
    result = [CustomURLProtocol propertyForKey:CustomeURLProtocolHasHandledKey inRequest:self.request] ;
    DDLog(@"result-original-immuatable:%@",result) ;
//    DDLog(@"is equivalent===%d",[CustomURLProtocol requestIsCacheEquivalent:request toRequest:self.request]) ;
    
//    request.HTTPMethod = @"POST" ;
    result = [CustomURLProtocol propertyForKey:CustomeURLProtocolHasHandledKey inRequest:request] ;
    DDLog(@"result-after-modify-method---%@, %@",result, request) ;
    
    NSURL * url = [NSURL URLWithString:@"http://www.qq.com"] ;
    request.URL = url ;
    result = [CustomURLProtocol propertyForKey:CustomeURLProtocolHasHandledKey inRequest:request] ;
    DDLog(@"result-after-modify-even-url---%@, %@",result, request) ;
    
    result = [CustomURLProtocol propertyForKey:@"anykey" inRequest:request] ;
    DDLog(@"result-anykey---%@, %@",result, request) ;
    
    NSMutableURLRequest * newRequest = [NSMutableURLRequest requestWithURL:url] ;
    result = [CustomURLProtocol propertyForKey:@"anykey" inRequest:newRequest] ;
    DDLog(@"result-new-created-request---%@,%@",result,newRequest) ;
    
    result = [CustomURLProtocol propertyForKey:CustomeURLProtocolHasHandledKey inRequest:newRequest] ;
    DDLog(@"result-new-created-request-with-same-key---%@,%@",result,newRequest) ;
    
    DDLog(@"-==================test--=======================") ;
    
    
    DDLog(@"host == %@",request.URL.host) ;
    
    DDLog(@"path == %@",request.URL.path) ;
    
    [CustomURLProtocol setProperty:@(YES) forKey:CustomeURLProtocolHasHandledKey inRequest:newRequest] ;
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

- (void)stopLoading
{
    DDLog(@"%s",__func__) ;
    [self.connection cancel] ;
    self.connection = nil ;
    
    [CustomURLProtocol removePropertyForKey:CustomeURLProtocolHasHandledKey inRequest:self.connection.currentRequest] ;
}


#pragma mark - NSURLConnectionDataDeledate 

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response
{
    DDLog(@"%s",__func__) ;
    
    DDLog(@"%@",request.allHTTPHeaderFields) ;

    // if response is empty, it means not redirect response was provided. just return the original request.
    if (!response) return request ;
    
    NSMutableURLRequest * newRequest = [request mutableCopy] ;
    
    NSHTTPURLResponse * response1 = (NSHTTPURLResponse *)response ;

    
    
    // Even the response is not empty, it doesn't mean we have to redirect. We have to check the status code to determine.
    
    if (response1.statusCode == 301 || response1.statusCode == 302) {
    
        DDLog(@"will redirect with status code: %li",response1.statusCode) ;
        
        NSString * urlStr = [response1 allHeaderFields][@"location"] ;
        
        newRequest.URL = [NSURL URLWithString:urlStr] ;
        
        [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response] ;
        
        return newRequest ;
    }
    
    return request ;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DDLog(@"%s",__func__) ;
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed] ;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DDLog(@"%s",__func__) ;
    
    [self.client URLProtocol:self didLoadData:data] ;
}

//- (nullable NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
//{
//    self.client url
//}

//- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

//- (nullable NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
//{
//    return cachedResponse ;
//}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DDLog(@"%s",__func__) ;
    [self.client URLProtocolDidFinishLoading:self] ;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DDLog(@"%s",__func__) ;
    [self.client URLProtocol:self didFailWithError:error] ;
    [self stopLoading] ;
}

//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
//{
//    DDLog(@"%s",__func__) ;
//    return YES ;
//}
//
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    DDLog(@"%s",__func__) ;
//    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge] ;
//}

@end
