//
//  ProtectAcessObject.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/26.
//  Copyright © 2018 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProtectAcessObject : NSObject {
    @protected
    NSMutableArray *items;
    NSMutableDictionary *dics;
    
    @private
    id _secret;
}

- (void)print;
- (void)test;

@end

@interface ProtectAcessSubObject : ProtectAcessObject

@end


NS_ASSUME_NONNULL_END


