//
//  ReplaceFileText.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ReplaceFileText.h"

@implementation ReplaceFileText

+ (void)replace
{
    NSError * error ;
    NSString * dirPath = @"/Volumes/soft/ios/TestAlert" ;
    BOOL isDirectory ;
    BOOL res = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDirectory] ;
    if (res == NO ) {
        NSAssert(NO, @"文件不存在") ;
    }
    
    NSArray * array = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:nil] ;
    
    for (NSString * str in array) {
        
        NSString * path = [dirPath stringByAppendingPathComponent:str] ;
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] ;
        if (dic[NSFileType] == NSFileTypeDirectory) {
            continue ;
        }
        
        //只修改.h和.m文件
        if (![path hasSuffix:@".h"] && ![path hasSuffix:@".m"]) {
            continue ;
        }
        
        NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] ;
//        DDLog(@"%@",content) ;

        
        NSString * a = @"ted\\sby\\s(.+?)\\son\\s.+?\n.+?right.+?年\\s(.+?)\\." ;
        NSRegularExpression * regEx = [NSRegularExpression regularExpressionWithPattern:a options:NSRegularExpressionCaseInsensitive error:nil] ;
        NSArray * results = [regEx matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)] ;
        NSMutableString * mutableStr = [NSMutableString stringWithString:content] ;
        for (int j =(int) results.count - 1 ; j >=0 ; j-- ) {
            NSTextCheckingResult * result = results[j] ;
            
            NSRange range1 = [result rangeAtIndex:1] ;
            NSRange range2 = [result rangeAtIndex:2] ;

            [mutableStr replaceCharactersInRange:range2 withString:@"dadong"] ;
            [mutableStr replaceCharactersInRange:range1 withString:@"dadong"] ;
        }
        
        [mutableStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error] ;
        if (error) {
            DDLog(@"%@",error.localizedDescription) ;
        }
    }
}



@end
