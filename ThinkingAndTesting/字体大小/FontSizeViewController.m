//
//  FontSizeViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "FontSizeViewController.h"
#import "UIFont+Adapter.h"

NSString  * const DDNetworkComeNotification = @"DDNetworkComeNotification" ;
NSString  * const DDNetworkComeNotification2 = @"DDNetworkComeNotification2" ;

@interface FontSizeViewController ()

@end

@implementation FontSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *purpleView = [UILabel new];
    purpleView.backgroundColor = [UIColor greenColor] ;
    [self.view addSubview:purpleView];
    purpleView.frame = CGRectMake(0, 100, DD_SCREEN_WIDTH, 15);
    purpleView.font = [UIFont relativeFontOfSize:15] ;
    purpleView.text = @"测试文字大小大小" ;
    
    UILabel *purpleView1 = [UILabel new];
    purpleView1.backgroundColor = [UIColor yellowColor] ;
    [self.view addSubview:purpleView1];
    purpleView1.frame = CGRectMake(0, 200, DD_SCREEN_WIDTH, 15);
    purpleView1.font = [UIFont absoluteFontOfSize:15] ;
    purpleView1.text = @"测试文字大小大小" ;

    if (DDNetworkComeNotification == DDNetworkComeNotification2) {
        //比较的是指针值是否相等
        DDLog(@"相等");
    }
    
    //如果两个字符串是用define定义的，#define abc @"abc"   则他们间的比较只能用isEqualToString: 并且比较的是内容而不是指针。
}



@end
