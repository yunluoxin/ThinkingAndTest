//
//  AppDelegate.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AppDelegate.h"
#import "DDNotifications.h"
#import "AFNetworkReachabilityManager.h"
#import "CacheDemoModel.h"
#import "DDAuthenticationViewController.h"
#import "FingerRecognizeViewController.h"
#import "ADViewController.h"
#import "ReplaceFileText.h"
#import "MJExtension.h"
#import "ConfigManager.h"
#import "DDNavigationController.h"

#import "CustomURLProtocol.h"
#import "AuthorizedChallengeIntercepterProtocol.h"

#import "NSObject+ZombiedObject.h"

extern NSString * const CURRENT_VC ;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // reister URLProtocol
//    [NSURLProtocol registerClass:[CustomURLProtocol class]] ;
    
//    EnabledZombiedMode() ;
    
    [NSURLProtocol registerClass:[AuthorizedChallengeIntercepterProtocol class]] ;
     
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[DDNavigationController alloc] initWithRootViewController:[NSClassFromString(CURRENT_VC) new]] ;
    
//    [self ADCheck];
//    [ReplaceFileText replace] ;
    
    [ConfigManager configure] ;
    
    [self cacheSetting];
    
    [self registerAllNotifications];
    AFNetworkReachabilityManager *m = [AFNetworkReachabilityManager sharedManager];
    /*
     这里需要注意，AFNetwork的网络可达性检测，如果不调用底下的startMonitoring的话，检测出来的状态永远是无网络！所以放在其他环境中，必须确保在使用这个方法之前已经调用过changeBlock
     */
    [m setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DDLog(@"检测到网络改变");
    }];
    [m startMonitoring];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    }
    
    
//    self.window.rootViewController = [FingerRecognizeViewController new];
//    DDAuthenticationViewController *vc = [DDAuthenticationViewController new] ;
//    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    return YES;
}
#pragma mark - 注册所有的通知

- (void)registerAllNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataErrorWithNotNetwork) name:[DDNotifications DATA_ERROR_NOT_NETWORK] object:nil];
    
}

- (void)ADCheck
{
    if (![AdManager handleAD]) {
        self.window.rootViewController = [FingerRecognizeViewController new];
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    DDAuthenticationViewController *vc = [DDAuthenticationViewController new] ;
//    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 由于无网络导致加载数据失败

- (void)loadDataErrorWithNotNetwork
{
    DDLog(@"当前无网络,数据加载失败");
}


- (void)cacheSetting
{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:1 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}


#pragma mark - 通知区域
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"%@",notificationSettings);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken--->%@",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error-->%@",error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userinfo--->%@",userInfo);
}


///
/// Core Data
///

- (void)saveContext
{
    NSError * error = nil ;
    
    NSManagedObjectContext *  managedObjectContext = self.managedObjectContext ;
    
    if (managedObjectContext && [managedObjectContext hasChanges]) {
        
        BOOL succeed = [managedObjectContext save:&error] ;
        
        DDLog(@"%@",error) ;
        
        if (succeed == NO) {
            abort() ;
        }
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        
        ///
        /// @warning 这里用后缀` momd` , 而不是建立文件时候的`xcdatamodeld`, 是因为：文件在编译发布之后，会变成CoreDataNotes.momd
        ///
        NSURL *  modelUrl = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"momd"] ;
        
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl] ;
        
        ///
        /// default load all databases in current main bundle.
        ///
//        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil] ;
        
    }
    return _managedObjectModel ;
}

- (NSPersistentStoreCoordinator *)persistentStoreCodinator
{
    if (!_persistentStoreCodinator) {
        NSURL * storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"dadong_test.sqlite"] ;
        _persistentStoreCodinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel] ;
        
        /*
         *  4种类型的存储选项：
         *  COREDATA_EXTERN NSString * const NSSQLiteStoreType API_AVAILABLE(macosx(10.4),ios(3.0));
         *  COREDATA_EXTERN NSString * const NSXMLStoreType API_AVAILABLE(macosx(10.4)) API_UNAVAILABLE(ios);
         *  COREDATA_EXTERN NSString * const NSBinaryStoreType API_AVAILABLE(macosx(10.4),ios(3.0));
         *  COREDATA_EXTERN NSString * const NSInMemoryStoreType API_AVAILABLE(macosx(10.4),ios(3.0));
        */
        [_persistentStoreCodinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:nil] ;
    }
    return _persistentStoreCodinator ;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init] ;
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCodinator ;
    }
    return _managedObjectContext ;
}
@end

/// setting current root viewController

NSString * const CURRENT_VC      =   @"PrivateAPIDemoViewController" ;

