//
//  AppDelegate.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


///
/// CoreData
///

/**
 *  <#note#>
 */
@property (nonatomic, strong)NSManagedObjectContext * managedObjectContext ;

/**
 *  <#note#>
 */
@property (nonatomic, strong)NSManagedObjectModel * managedObjectModel ;
/**
 *  <#note#>
 */
@property (nonatomic, strong)NSPersistentStoreCoordinator * persistentStoreCodinator ;

- (void)saveContext ;

- (NSURL *)applicationDocumentsDirectory ;

@end

