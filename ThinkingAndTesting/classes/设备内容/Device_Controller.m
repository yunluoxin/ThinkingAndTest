//
//  Device_Controller.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "Device_Controller.h"
#import "sys/utsname.h"

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

    
    [self userAgentStr] ;
    
    
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.25 animations:^{
        [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].isStatusBarHidden ;
    }] ;
    
    
    NSString * str = @"iVBORw0KGgoAAAANSUhEUgAAAAYAAAAECAYAAACtBE5DAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBNYWNpbnRvc2giIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OENDRjNBN0E2NTZBMTFFMEI3QjRBODM4NzJDMjlGNDgiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OENDRjNBN0I2NTZBMTFFMEI3QjRBODM4NzJDMjlGNDgiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo4Q0NGM0E3ODY1NkExMUUwQjdCNEE4Mzg3MkMyOUY0OCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo4Q0NGM0E3OTY1NkExMUUwQjdCNEE4Mzg3MkMyOUY0OCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PqqezsUAAAAfSURBVHjaYmRABcYwBiM2QSA4y4hNEKYDQxAEAAIMAHNGAzhkPOlYAAAAAElFTkSuQmCC" ;
    
    NSData * date = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters] ;
    
    UIImage * image =  [[UIImage alloc] initWithData:date scale:1] ;
    UIImageView * imageV = [[UIImageView alloc] initWithImage:image] ;
    [self.view addSubview:imageV] ;
    imageV.center = self.view.center ;
}

- (NSString *)userAgentStr{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], deviceString, [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
    return userAgent;//Coding_iOS/4.0.8.201611041630 (x86_64; iOS 10.1; Scale/2.00)
}

@end
