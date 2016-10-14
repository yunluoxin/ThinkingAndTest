//
//  DynamicClass.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/13.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicClass : NSObject
+ (Class)makeClassWithClassName:(NSString *)newClassName extentsClass:(Class)originClazz ;
@end
