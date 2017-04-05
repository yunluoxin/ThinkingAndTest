//
//  DDUtils+PrivateAPI.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/31.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDUtils+PrivateAPI.h"
#import <objc/runtime.h>

@implementation DDUtils (PrivateAPI)

+ (NSArray *)bundleIDsOfAllInstalledApps
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray * apps = [workspace performSelector:@selector(allApplications)] ;
    NSLog(@"apps: %@", apps);
    return apps ;
}

@end
