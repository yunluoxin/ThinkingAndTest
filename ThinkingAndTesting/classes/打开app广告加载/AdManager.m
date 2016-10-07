//
//  AdManager.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/13.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "AdManager.h"
#import "AFHTTPSessionManager.h"
#import "ADViewController.h"

#define ADCurrentImagePath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingString:@"/currentImage.png"])
#define ADNewImagePath     ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingString:@"/newImage.png"])

@implementation AdManager

+ (BOOL)isExistAdImageInLocal
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:ADCurrentImagePath] || [[NSFileManager defaultManager] fileExistsAtPath:ADNewImagePath]) {
        return YES ;
    }
    return NO ;
}

+ (NSString *)getAdImagePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:ADNewImagePath]) {
        //移除旧的照片
        [[NSFileManager defaultManager] removeItemAtPath:ADCurrentImagePath error:NULL];
        
        //新照片改名（即移动）
        [[NSFileManager defaultManager] moveItemAtPath:ADNewImagePath toPath:ADCurrentImagePath error:NULL];
        
//      <-----注意！！！！！！直接移动当做替换同名文件会失败！！！必须先移除之前的---->
    }
    return ADCurrentImagePath ;
}

+ (void)loadAdImageFromNet
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableSet *contentTypes =  [manager.responseSerializer.acceptableContentTypes mutableCopy];
    [contentTypes addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = contentTypes ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    long time = [NSDate timeIntervalSinceReferenceDate];

    [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (time %2 == 0) {
            [self downloadImage:@"http://c.cnfolimg.com/h/20140415/97/14074706586292062025.jpg"];
        }else{
            [self downloadImage:@"http://cimage.tianjimedia.com/uploadImages/2015/002/U65052CKUDYP.jpg"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

+ (void)downloadImage:(NSString *)imageUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:imageUrl]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            [data writeToFile:ADNewImagePath atomically:YES];
        }
    }];
    [task resume];
}

+ (BOOL)handleAD
{
    if ([AdManager isExistAdImageInLocal]) {        //本地存在广告图片，则跳转广告控制器
        [UIApplication sharedApplication].keyWindow.rootViewController = [ADViewController new];
        return YES ;
        
    }else{                  //本地无广告，则在后台下载广告，并且直接返回NO，跳转需要的控制器
        DDLog(@"无广告");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [AdManager loadAdImageFromNet];
        });
        return NO ;
    }
}
@end
