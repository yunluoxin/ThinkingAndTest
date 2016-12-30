//
//  CertificationUtils.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CertificationUtils.h"

@interface CertificationUtils () < NSURLConnectionDelegate >

@end

@implementation CertificationUtils

+ (void)test
{
    NSURL * url = [NSURL URLWithString:@"https://api.m.kachemama.com/mobile/home/data"] ;
    //    NSURL * url = [NSURL URLWithString:@"https://www.qcloud.com/?utm_source=bdppzq&utm_medium=line&utm_campaign=baidu"] ;
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url] ;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {
            NSLog(@"%@",connectionError) ;
            return  ;
        }
        
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        
        DDLog(@"%@",str) ;
        
    }] ;
    
    [NSURLConnection connectionWithRequest:request delegate:self] ;

}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    SecTrustRef trustRef = challenge.protectionSpace.serverTrust ;
    
    CFIndex count = SecTrustGetCertificateCount(trustRef) ;
    
    for (NSInteger i = 0 ; i < count; i ++) {
        SecCertificateRef cert = SecTrustGetCertificateAtIndex(trustRef, i) ;
        
        CFDataRef data = SecCertificateCopyData(cert) ;
        
        NSData * data2 = (__bridge id)data ;
        
        NSString * path = [NSString stringWithFormat:@"/Users/dadong/Desktop/%zd.cer",i] ;
        
        [data2 writeToFile:path atomically:YES] ;
        
        CFRelease(data) ;
    }
}
@end
