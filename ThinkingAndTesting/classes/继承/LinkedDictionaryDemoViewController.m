//
//  LinkedDictionaryDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/6/3.
//  Copyright © 2019 dadong. All rights reserved.
//

#import "LinkedDictionaryDemoViewController.h"
#import "DDLinkedDictionary.h"

@interface LinkedDictionaryDemoViewController ()
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation LinkedDictionaryDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DDLinkedDictionary *dic = [DDLinkedDictionary dictionary];
    dic[@"d"] = @"b";
    dic[@"c"] = @"d";
    dic[@"a"] = @"a";
    DDLog(@"%@", dic);
    
    dic[@"c"] = nil;
    DDLog(@"%@", dic);
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        DDLog(@"%@,%@", key, obj);
    }];
    
    
    NSMutableDictionary *dicM = @{}.mutableCopy;
    dicM[@"d"] = @"b";
    dicM[@"c"] = @"d";
    DDLog(@"%@", dicM);
    
    dicM[@"d"] = nil;
    DDLog(@"%@", dicM);

    [self p_getNetworkTime];
}


/**
 通过网络-获取当前北京时间
 */
- (void)p_getNetworkTime {
    NSString *URL = @"http://www.beijing-time.org/time.asp";
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: URL]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"HEAD"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    self.task =
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable res, NSError * _Nullable error) {
        if (error || !res || ![res isKindOfClass:NSHTTPURLResponse.class]) return;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)res;
        if (response.statusCode / 100 != 2) return;
        
        NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
        date = [date substringFromIndex:5];
        date = [date substringToIndex:[date length]-4];
        static NSDateFormatter *formatter = nil;
        if (!formatter) {
            formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
        }
        NSDate *netDate = [[formatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
        
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: netDate];
        NSDate *localeDate = [netDate  dateByAddingTimeInterval:interval];
        
    }];
    
    [self.task resume];
}
@end
