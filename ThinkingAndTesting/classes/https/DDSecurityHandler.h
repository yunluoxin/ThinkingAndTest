//
//  DDSecurityHandler.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/28.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSecurityHandler : NSObject

/**
     验证鉴权挑战是否可以通过
 */
+ (BOOL)vaildateChallenge:(NSURLAuthenticationChallenge *)challenge ;
@end
