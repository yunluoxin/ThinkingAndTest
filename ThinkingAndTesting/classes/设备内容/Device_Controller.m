//
//  Device_Controller.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "Device_Controller.h"

@interface Device_Controller ()

@end

@implementation Device_Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设备的内容获取" ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    
    //iPhone ,   iPod touch ,    iPad
    DDLog(@"模型名字------> %@",[UIDevice currentDevice].model) ;
    
    
    
    //可以在设置中设置的! 模拟器默认都是带有"Simulator"
    DDLog(@"设备名字，自定义的---->%@",[UIDevice currentDevice].name) ;
    
    
    //未知
    DDLog(@"%@",[UIDevice currentDevice].localizedModel) ;
    
    
    
    //系统名字，iPhone OS / Mac OS X (估计的，没实测)
    DDLog(@"系统名字---->%@",[UIDevice currentDevice].systemName) ;     //iPhone OS
    
    
    
    //系统版本号
    DDLog(@"系统版本号---->%@",[UIDevice currentDevice].systemVersion) ; // 9.1.0 | 8.4.1 等等
    
    
    //屏幕宽高
    DDLog(@"宽： %f, 高： %f", [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height) ;
    
    
    
    //info.Plist文件里面的内容
    NSDictionary * infoDic = [NSBundle mainBundle].infoDictionary ;
    DDLog(@"%@",[[NSBundle mainBundle] infoDictionary] ) ;
    DDLog(@"当前APP版本号：%@",infoDic[@"CFBundleShortVersionString"] );
    DDLog(@"当前APP内部编译版本号：%@",infoDic[@"CFBundleVersion"] );
    
    
    
    
    
    
    
//判断一台手机是不是 iPhone
#define TARGET_IS_IPHONE    ([[UIDevice currentDevice].model isEqualToString:@"iPhone"])

//是不是模拟器
#define TARGET_IS_SIMULATOR ([[UIDevice currentDevice].name hasSuffix:@"Simulator"])
    
    

    
//iPhone 4 / 4S
#define TARGET_IS_IPHONE4 (  [[UIDevice currentDevice].model isEqualToString:@"iPhone"] && (( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.height == 480) || (!UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.width == 480 ) )   )
    
    DDLog(@"设备是iPhone5吗----%d",TARGET_IS_IPHONE4) ;
    

    
    
//iPhone 5 / 5S / 5SE
#define TARGET_IS_IPHONE5 (  [[UIDevice currentDevice].model isEqualToString:@"iPhone"] && (( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.height == 568) || (!UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.width == 568 ) )   )
    
    DDLog(@"设备是iPhone5吗---%d",TARGET_IS_IPHONE5) ;
    

    
    
//iPhone 6 / 6S
#define TARGET_IS_IPHONE6 (  [[UIDevice currentDevice].model isEqualToString:@"iPhone"] && (( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.height == 667) || (!UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.width == 667 ) )   )
    
    DDLog(@"设备是iPhone6吗---%d",TARGET_IS_IPHONE6) ;
    
    
    
    
//iPhone 6p / 6Sp
#define TARGET_IS_IPHONE6_PLUS (  [[UIDevice currentDevice].model isEqualToString:@"iPhone"] && (( UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.height == 736) || (!UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) && [UIScreen mainScreen].bounds.size.width == 736 ) )   )
    
    DDLog(@"设备是iPhone6p吗---%d",TARGET_IS_IPHONE6_PLUS) ;

}

@end
