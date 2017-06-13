//
//  SimplifyURLProtocol.h
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  实验得出：只写 验证ssl的代理方法，只是验证数据，但是无法使请求接收到数据！！！ 故此类`SimplifyURLProtocol`是无法直接用的！！！
//  必须有`AuthorizedChallengeIntercepterProtocol.h`里面的所有代理方法重写
//
@interface SimplifyURLProtocol : NSURLProtocol

@end
