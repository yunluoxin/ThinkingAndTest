//
//  NSObject+FastCoreData.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FastCoreData)

+ (NSArray *)fetchRequestWithConditions:(NSString *)conditions ;


+ (NSArray *)fetchRequestWithConditions:(NSString *)conditions sortByKey:(NSString *)sortkey ascending:(BOOL)ascending ;

@end
