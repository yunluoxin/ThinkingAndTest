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

+ (NSArray *)fetchRequestWithConditions:(NSString *)conditions
{
    return [self fetchRequestWithConditions:conditions sortByKey:nil ascending:NO] ;
}

+ (NSArray *)fetchRequestWithConditions:(NSString *)conditions sortByKey:(NSString *)sortkey ascending:(BOOL)ascending
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
    
    if (conditions && conditions.length > 0) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:conditions] ;
        request.predicate = predicate ;
    }
    
    if (sortkey && sortkey.length > 0) {
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortkey ascending:ascending] ;
        request.sortDescriptors = @[sortDescriptor] ;
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
