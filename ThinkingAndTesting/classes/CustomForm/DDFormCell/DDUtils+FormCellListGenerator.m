//
//  DDUtils+FormCellListGenerator.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDUtils+FormCellListGenerator.h"
#import "FormItem.h"
#import <objc/runtime.h>

@implementation DDUtils (FormCellListGenerator)

+ (void)generatePlistWithObject:(id)obj toFile:(NSString *)path
{
    if (!obj) {
        return ;
    }
    
    NSDictionary *dic = [self serializationWithObject:obj] ;
    NSArray *keySet =  dic.allKeys ;
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:keySet.count] ;
    for (NSString * key in keySet) {
        FormItem *item = [FormItem new] ;
        item.propertyName = key ;
        item.obj = dic[key] ;
        [arrayM addObject:item] ;
    }
    
    NSArray *arr = [self serializationWithObject:arrayM] ;
//    NSLog(@"%@",arr) ;

    if (!path) {
        //可以写到自己桌面，取文件方便
        path = @"/Users/dadong/Desktop/b.plist" ;
    }
    [arr writeToFile:path atomically:YES] ;
    
    
    dic = nil ;
    arrayM = nil ;
    arr = nil ;
}


+ (id)serializationWithObject:(id)obj
{
    if (!obj) {
        return nil;
    }

    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSValue class]] || [obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrayM = [NSMutableArray array] ;
        for (id o in obj) {
            [arrayM addObject:[self serializationWithObject:o]] ;
        }
        return [arrayM copy] ;
    }
    
    u_int count ;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithCapacity:count] ;
    for (int i = 0 ; i < count;  i ++ ) {
        const char * propertyName = property_getName(properties[i]);
        NSString * name = [[NSString alloc]initWithUTF8String:propertyName] ;
        id value = [obj valueForKey:name] ;
        if (value) {
            dicM[name] = [self serializationWithObject:value] ;
        }else{
            dicM[name] = @"" ;
//            dicM[name] = [NSNull null] ;//这一步骤坑死了！要存储到plist，必须明确是string,bool,number,array中的一个，不能是其他类型，包括null。不存储到plist随便什么类型！
        }
    }
    free(properties);
    return [dicM copy] ;
}
@end
