//
//  DDSecurityHandler.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDSecurityHandler.h"

@implementation DDSecurityHandler

+ (BOOL)vaildateChallenge:(NSURLAuthenticationChallenge *)challenge
{
    //错误太多次了，直接返回错误
    if (challenge.previousFailureCount > 5)
    {
        return NO ;
    }
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
    {
        static NSMutableArray * certs ;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray * paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"cer" inDirectory:nil] ;
            
            certs = @[].mutableCopy ;
            
            for (NSString * path in paths)
            {
                NSData * data = [[NSData alloc] initWithContentsOfFile:path] ;
                
                SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)data) ;
                
                [certs addObject:(__bridge_transfer id)cert ] ;
                
                // CFRelease(cert) ;
            }
        });
        
        SecTrustRef trustRef = challenge.protectionSpace.serverTrust ;
        
        if (certs.count > 0)
        {
            //设置根证书
            SecTrustSetAnchorCertificates(trustRef, (__bridge CFArrayRef)certs ) ;
            SecTrustSetAnchorCertificatesOnly(trustRef, NO) ;
        }
        
        SecTrustResultType result ;
        OSStatus status = SecTrustEvaluate(trustRef, &result) ;
        
        if (status == errSecSuccess)
        {
            DDLog(@"校验完成") ;
            
            if (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)
            {
                DDLog(@"验证通过") ;
                return YES ;
            }
            else
            {
                DDLog(@"验证失败") ;
                return NO ;
            }
        }
        
    }
    
    return NO ;
    
}

@end
