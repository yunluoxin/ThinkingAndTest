//
//  NSDateDemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "NSDateDemoViewController.h"

@interface NSDateDemoViewController ()

@end

@implementation NSDateDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self method1];
//    });
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self method2];
//    });

    NSDate *now = [NSDate date];
    NSDate *now2 = [NSDate dateWithTimeIntervalSinceNow:0];
    DDLog(@"%@,%@",now,now2);
    
    NSDate *date1970 = [NSDate dateWithTimeIntervalSince1970:0];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date1970];
    DDLog(@"%@,%f",date1970,timeInterval);
    
    NSDate *newDate = [date1970 dateByAddingTimeInterval:timeInterval];
    DDLog(@"新世纪%@",newDate);
    
    NSDate *date1970new = [now dateByAddingTimeInterval:-timeInterval];
    DDLog(@"%@",date1970new);
}

- (void)method1
{
    @autoreleasepool {
    CFTimeInterval previous = CFAbsoluteTimeGetCurrent() ;
    for (int i = 0 ; i < 50000000; i ++ ) {
            NSString *string = @" Abcsdafsadfsdfsdafsadfsdafas" ;
            string = [string lowercaseString];
            string = [string stringByAppendingString:@"xyz"];
            //        DDLog(@"%@",string);
    }
    CFTimeInterval now = CFAbsoluteTimeGetCurrent() ;
    DDLog(@"%f",now - previous);
    }
}

- (void)method2
{
    CFTimeInterval previous = CFAbsoluteTimeGetCurrent() ;
    for (int i = 0 ; i < 50000000; i ++ ) {
        @autoreleasepool {
            NSString *string = @" Abcasdfasfdsasafsadfsadfsadfd" ;
            string = [string lowercaseString];
            string = [string stringByAppendingString:@"xyz"];
            //        DDLog(@"%@",string);
        }
    }
    CFTimeInterval now = CFAbsoluteTimeGetCurrent() ;
    DDLog(@"%f",now - previous);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
