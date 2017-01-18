//
//  NSObject+DDAdd.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/1/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DDAdd)

- (void)setAssociateValue:(id)value forKey:(const void *) key ;

- (id)getAssociateValueByKey:(const void *)key ;

- (void)setAssociateWeakValue:(id)value forKey:(const void *)key ;

- (void)removeAllAssociateValues ;

@end
