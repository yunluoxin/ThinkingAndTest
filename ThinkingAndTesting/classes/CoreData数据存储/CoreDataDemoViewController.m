//
//  CoreDataDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CoreDataDemoViewController.h"
#import "Man+CoreDataProperties.h"
#import "AppDelegate.h"
#import "NSObject+FastCoreData.h"

@interface CoreDataDemoViewController ()

@end

@implementation CoreDataDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self insertData] ;
    
    [self fetchDataSimply] ;
}

// 插入数据
- (void)insertData
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    NSManagedObjectContext * context = [delegate managedObjectContext] ;
    Man * test = [NSEntityDescription insertNewObjectForEntityForName:@"Man" inManagedObjectContext:context] ;
    test.name = @"dadong" ;
    test.age = @(100) ;
    test.sex = @"男" ;
    
    NSError * error ;
    BOOL result = [context save:&error] ;
    if (!result || error) {
        DDLog(@"%@",error.localizedDescription) ;
    }
}

// 取出数据
- (void)fetchData
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    NSManagedObjectContext * context = [delegate managedObjectContext] ;
    NSEntityDescription * desc = [NSEntityDescription entityForName:@"Man" inManagedObjectContext:context] ;
    NSFetchRequest * request = [[NSFetchRequest alloc] init] ;
    request.entity = desc ;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name = 'xadong'"] ;
    
    request.predicate = predicate ;
    
    NSError * error ;
    NSArray * array = [context executeFetchRequest:request error:&error] ;
    if (!error) {
        NSLog(@"%@",array) ;
    }else{
        DDLog(@"%@",error.localizedDescription) ;
    }
}

/// 删除数据
- (void)deleteData
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    NSManagedObjectContext * context = [delegate managedObjectContext] ;
    NSEntityDescription * desc = [NSEntityDescription entityForName:@"Man" inManagedObjectContext:context] ;
    NSFetchRequest * request = [[NSFetchRequest alloc] init] ;
    request.entity = desc ;
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name = 'xadong'"] ;
    
    request.predicate = predicate ;
    
    NSError * error ;
    NSArray * array = [context executeFetchRequest:request error:&error] ;
    if (!error) {
        if (array && array.count > 0) {
            NSManagedObject * o = [array lastObject] ;
            [context deleteObject:o] ;
            [context save:&error] ;
        }else{
            DDLog(@"数组不存在") ;
            return ;
        }
    }
    
    if (error) {
        DDLog(@"%@",error.localizedDescription) ;
    }else{
        DDLog(@"删除成功!!") ;
    }
}

- (void)fetchDataSimply
{
    NSArray * array = [Man fetchRequestWithConditions:nil] ;
//    [Man fetchRequestWithConditions:@{
//                                      @"name = %@ and age = %@":@[
//                                                              @"dadong",
//                                                              @"100"
//                                                              ]
//                                      }] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self deleteData] ;
}

@end
