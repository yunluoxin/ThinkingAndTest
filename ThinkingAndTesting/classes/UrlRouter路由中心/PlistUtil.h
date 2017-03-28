//
//  PlistUtil.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistUtil : NSObject

+ (NSDictionary *)dictionaryWithFilePath:(NSString *)path ;

+ (BOOL)verfiyDataIsLegalWithOriginalDictionary:(NSDictionary *)dic ;

+ (NSDictionary *)extractConfigsFromLegalOriginalDictionary:(NSDictionary *)dic ;

+ (NSDictionary *)chooseConfigsWisely ;

+ (void)writeDataToCachedPlistFile:(NSDictionary *)originalDic ;

+ (BOOL)removeCachedPlistFile ;

+ (void)startDownloadingConfigFile ;
@end
