//
//  NSObject+FastCoreData.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/18.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSObject+FastCoreData.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "MJExtension.h"

@implementation NSObject (FastCoreData)

+ (NSArray *)fetchRequestWithConditions:(NSDictionary<NSString*, NSArray*> *)conditions
{
    if (![self isSubclassOfClass:[NSManagedObject class]] ) {
        NSAssert(NO, @"this is for CoreData objects!!!") ;
        return nil ;
    }
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    NSManagedObjectContext * context = [delegate managedObjectContext] ;
    
    NSAssert(context != nil, @"context can't be null") ;
    
    NSMutableArray * datas = nil ;
    
//    id obj = self ;
//    NSFetchRequest * request = [obj performSelector:@selector(fetchRequest)] ;

    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:[NSString stringWithUTF8String:object_getClassName(self)]] ;
    
    if (conditions && conditions.count > 0) {
        for (NSString * formatKey in conditions) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:formatKey argumentArray:conditions[formatKey]] ;
            request.predicate = predicate ;
            break ;
        }
    }
    
    NSError * error ;
    NSArray * array = [context executeFetchRequest:request error:&error] ;
    if (!error && array && array.count > 0) {
        datas = [self mj_keyValuesArrayWithObjectArray:array] ;
        DDLog(@"%@",datas) ;
        return datas ;
    }
    
    return nil ;

}
@end
