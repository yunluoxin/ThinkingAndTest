//
//  CertificationUtils.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CertificationUtils : NSObject

/**
    用来保存某个网址的所有https证书，包含整个证书链的
 */
+ (void)savedCertificatesOfUrl:(NSString *)url ;

@end
