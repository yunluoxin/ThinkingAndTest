
//
//  AlipayResultDemoViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/26.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AlipayResultDemoViewController.h"
#import "DDUtils.h"
#import "MJExtension.h"
@interface AlipayResultDemoViewController ()

@end

@implementation AlipayResultDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *result = @"partner=\"2088121467764990\"&seller_id=\"kachemama@163.com\"&out_trade_no=\"2016022605910\"&subject=\"\\U5361\\U8f66\\U5988\\U5988\\U8ba2\\U5355[2016022605910]\"&body=\"\\U94a2\\U677f\\U9500\\U5965\\U5a01  30X260\"&total_fee=\"0.01\"&notify_url=\"http://m-sta.kachemama.com/mobile/payment/callback/alipay\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&success=\"true\"&sign_type=\"RSA\"&sign=\"TAzBeJad+3wt6PEAYhutgwcx7NrHAKVHNQx+d1dPCr4dRZJFt/muaVxnoBAX3RSo0KJbYdWRAH24HlYzce/zLXxT6WNs1UPfOZCuOXM4lrDbdkmc7MzSSfeQ0OINkxAcwrhgo3P0G7VxAICUS/6z1grWuUEL9fNH9ARtb9gg4u8=\"";
//    DDLog(@"%@",result);
    NSDictionary *d = @{@"我没":@"wo我们没",@"abc":@"我"};
    DDLog(@"%@",[d mj_JSONObject]);
    
    
    NSDictionary *dic = [DDUtils convertAlipayResultStrToDic:result];
//    DDLog(@"%@",dic);
    DDLog(@"%@",dic[@"subject"]);
    
    
    NSNumber *num = nil ;
    NSString *str = [NSString stringWithFormat:@"%@",num];

    if ([str isEqualToString:@"(null)"]) {
    DDLog(@"%@",str);
    }
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
