
//
//  NSURLSessionDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/20.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "NSURLSessionDemoViewController.h"
#import "AppDelegate+DD_BackgroundSession.h"

static NSString * const DDBackgroundSessionIdentifier = @"com.dadong.test" ;

@interface NSURLSessionDemoViewController ()<NSURLSessionDownloadDelegate>

/**
 *
 */
@property (nonatomic, strong)NSURLSession * session ;

@end

@implementation NSURLSessionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSURLSession Demo" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
//    return ;

    
    
    [self setupBackgroundSession] ;
    
}

- (void)setupGlobalSession
{
    /// 使用全局的
    /// 1. 缓存
    /// 2. Cookie
    /// 3. 证书
    NSURLSession * session = [NSURLSession sharedSession] ;
    self.session = session ;
    
    [self _dd_openNetwork] ;
}


- (void)setupEphemeralSession
{
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration ephemeralSessionConfiguration] ;
    self.session = [NSURLSession sessionWithConfiguration:config] ;
    
    [self _dd_openNetwork] ;
}


- (void)setupBackgroundSession
{
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:DDBackgroundSessionIdentifier] ;
    
    /// 后台会话不支持Block回调！！！必须设置代理
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil] ;
    
    
    [self.session downloadTaskWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1490061203&di=d0f7f249faa5237dce54add33aa720f6&src=http://h.hiphotos.baidu.com/image/pic/item/f9dcd100baa1cd11dd1855cebd12c8fcc2ce2db5.jpg"]] ;
}

- (void)_dd_openNetwork
{
    [self clearAllCookies] ;
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"http://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ) ;
    }] resume];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"http://m-dev.kachemama.com/mobile/home/data"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ) ;
    }] resume];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",self.session.configuration.HTTPCookieStorage.cookies) ;
}


- (void)clearAllCookies
{
    NSEnumerator *enumerator = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies.objectEnumerator ;
    NSHTTPCookie * cookie = nil ;
    while (cookie = [enumerator nextObject] ) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie] ;
    }
}

#pragma mark - 

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"didFinishDownloadingToURL:%@",location) ;
    
    
    NSURL * destinateUrl = [NSURL URLWithString:@"file:///Users/dadong/Desktop/girl.jpg"] ; // here I use Mac computer's Desktop for destination folder. Attention use `file://` otherwise it will be wrong.
    
    /// move tmp file to the path what we want to save them.
    
    NSError * error ;
    BOOL result = [[NSFileManager defaultManager] moveItemAtURL:location toURL:destinateUrl error:&error] ;
    if (result) {
        DDLog(@"move successful") ;
    }else{
        if (error) {
            DDLog(@"%@",error.localizedDescription) ;
        }
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    NSProgress * progress = [NSProgress progressWithTotalUnitCount:totalBytesExpectedToWrite] ;
    NSLog(@"%f",totalBytesWritten / (double)totalBytesExpectedToWrite ) ;
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

// 后台下载完成之后，系统调用的。 From Appdelegate -- > here
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session NS_AVAILABLE_IOS(7_0)
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    
    if (delegate.backgroundSessionDidCompletedHandler){
        void (^block)() = delegate.backgroundSessionDidCompletedHandler ;
        delegate.backgroundSessionDidCompletedHandler = nil ;
        block() ;
    }
}

@end
