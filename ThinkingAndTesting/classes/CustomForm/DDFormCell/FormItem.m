//
//  FormItem.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FormItem.h"

@implementation FormItem

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic] ;
    }
    return self ;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{} ;

+ (void)convertObjectData:(id)obj IntoArrays:(NSArray<FormGroup *> *)groups
{
    if (!groups || groups.count == 0) {
        return ;
    }
    
    for (FormGroup *group in groups) {
        for (FormItem * item in group.items) {
            id value = [obj valueForKey:item.propertyName] ;
            item.obj = value ;
        }
    }
}

+ (void)collectDataFromArrays:(NSArray<FormGroup *> *)groups toObject:(id)obj
{
    if (!groups || groups.count == 0 || !obj) {
        return ;
    }
    
    for (FormGroup *group in groups) {
        for (FormItem * item in group.items) {
            [obj setValue:item.obj forKey:item.propertyName] ;
        }
    }
}

@end



@implementation FormItemExtra
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic] ;
    }
    return self ;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{} ;
@end




@implementation FormGroup
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic] ;
    }
    return self ;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{} ;
@end