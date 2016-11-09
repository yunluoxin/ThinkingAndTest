//
//  TestImageNamedController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/31.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TestImageNamedController.h"
#import "AutoReleaseObject.h"

#define  cachePath ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject ] stringByAppendingPathComponent:@"images"])

@interface TestImageNamedController ()

@end

@implementation TestImageNamedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self generateImages] ;

    
//    [self testImageNamed] ;
    
    
    
//    [self testData] ;

    CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting|kCFRunLoopAfterWaiting, YES, 111111, &callback, NULL) ;

    CFRunLoopAddObserver(CFRunLoopGetMain(), observerRef, kCFRunLoopDefaultMode) ;
//    CFRelease(observerRef) ;
    
//    BOOL result = CFRunLoopContainsObserver(CFRunLoopGetMain(), observerRef,kCFRunLoopCommonModes);
//    result = CFRunLoopObserverIsValid(observerRef) ;
//    DDLog(@"结果是%d",result) ;
}

void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    if ( CFRunLoopObserverGetOrder(observer) == 111111 ) {
        if (activity == kCFRunLoopBeforeWaiting) {
            DDLog(@"休眠前....") ;
        }else{
            DDLog(@"醒来拉。。。。") ;
        }
    }
}

- (void)test{

    for (int i = 0 ; i < 2 ; i ++) {

        AutoReleaseObject * obj = [AutoReleaseObject sharedInstance];
//        DDLog(@"%ld",obj.retainCount) ;
    }

    DDLog(@"safsdf") ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
        [self test ] ;
}



- (void)testImageNamed
{
    //内存24.9MB， 不加autoreleasepool或者pool加在for之外 则 35.2MB， 原因未知 ------------------
    for (int i = 0 ; i < 1000 ; i ++) {
        @autoreleasepool {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%d.png",cachePath,i] ] ;
            image = nil ;
        }
    }
}


- (void)testData
{
    //以data方式加载，内存23.4MB
    for (int i = 0 ; i < 1000 ; i ++) {
        UIImage * image = [UIImage dd_imageNamed:[NSString stringWithFormat:@"%@/%d.png",cachePath,i] ] ;
        image = nil ;
    }
}


//随机生成1000张图片
- (void)generateImages
{
    for (NSUInteger i = 0 ; i < 1000; i ++) {
        @autoreleasepool {
            UIImage * image = [UIImage imageWithColor:RandomColor size:self.view.bounds.size] ;
            NSData * data = UIImagePNGRepresentation(image) ;
            image = nil ;
            [data writeToFile:[NSString stringWithFormat:@"%@/%ld.png",cachePath,i] atomically:YES] ;
            data = nil ;
        }
    }
    

}

- (void)dealloc
{
//    [super dealloc] ;
}
@end
