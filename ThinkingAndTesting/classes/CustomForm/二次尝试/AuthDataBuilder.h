//
//  AuthDataBuilder.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDBaseCellConfig.h"
#import "DriverAuthorizedForm.h"

@interface AuthDataBuilder : NSObject

+ (NSArray <DDBaseCellConfig *> * ) buildDataFrom:(DriverAuthorizedForm *)form ;

+ (void)composeForm:(DriverAuthorizedForm *)form withConfigs:(NSArray *)configs ;

+ (NSString *)vaildDatas:(NSArray * )configs ;
@end
