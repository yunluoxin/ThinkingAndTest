//
//  CoreDataDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/16.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CoreDataDemoViewController.h"
#import "test+CoreDataModel.h"
#import "AppDelegate.h"
@interface CoreDataDemoViewController ()

@end

@implementation CoreDataDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    NSManagedObjectContext * context = [delegate managedObjectContext] ;
    Man * test = [NSEntityDescription insertNewObjectForEntityForName:@"Man" inManagedObjectContext:context] ;
    test.name = @"addong" ;
    test.age = 100 ;
    test.sex = @"男" ;

    NSError * error ;
    BOOL result = [context save:&error] ;
    if (!result || error) {
        DDLog(@"%@",error.localizedDescription) ;
    }
}


@end
