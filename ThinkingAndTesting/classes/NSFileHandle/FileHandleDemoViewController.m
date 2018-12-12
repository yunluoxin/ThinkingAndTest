//
//  FileHandleDemoViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/12/12.
//  Copyright © 2018 dadong. All rights reserved.
//

#import "FileHandleDemoViewController.h"
#include <sys/param.h>
#include <sys/mount.h>

#define filePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.txt"]

@interface FileHandleDemoViewController ()

@end

@implementation FileHandleDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        DDLog(@"%@", filePath);
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    [self writeTest];
    
    [self readTest];
    
    DDLog(@"%.2f",[self.class freeDiskSpaceInBytes]);
}

- (void)readTest {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle) {
        NSAssert(false, @"打不开文件以读取！");
        return;
    }
    
    
    int position = (int)[handle offsetInFile];
    DDLog(@"初始位置%d", position);
    
    [handle seekToFileOffset:0];
    
    NSData *txtData = [handle readDataToEndOfFile];                 ///< 是从当前指针位置开始，读取到最后！不是从0开始
    NSString *txt = [[NSString alloc] initWithData:txtData encoding:NSUnicodeStringEncoding];
    DDLog(@"读到的数据是 %@", txt);
    DDLog(@"长度是 %ld", txt.length);

//    DDLog(@"%ld", @"的人\0\0\0\0\0test".length);
    
    int position1 = (int)[handle offsetInFile];
    DDLog(@"结束位置%d", position1);
    
    [handle seekToFileOffset:0];
    NSData *allData = [handle availableData];
    NSString *allTxt = [[NSString alloc] initWithData:allData encoding:NSUnicodeStringEncoding];
    DDLog(@"读到的数据是 %@", allTxt);

    [handle closeFile];
}

- (void)writeTest {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        NSAssert(false, @"打不开文件以写入！");
        return;
    }
    
    int position = (int)[handle offsetInFile];
    DDLog(@"初始位置%d", position);
    
    [handle writeData:[@"的3" dataUsingEncoding:NSUnicodeStringEncoding]];
    
    int position1 = (int)[handle offsetInFile];
    DDLog(@"结束位置1: %d", position1);
    
    [handle seekToFileOffset:4];
    
    
    [handle writeData:[@"我在哪里" dataUsingEncoding:NSUnicodeStringEncoding]];     ///< 写入后指针也会移动到相应的位置， 如果原来是有更多的字符，会慢慢被替换

    int position2 = (int)[handle offsetInFile];
    DDLog(@"结束位置2: %d", position2);
    
    [handle truncateFileAtOffset:4];                    ///< 截取到哪里，也会导致指针移动到哪里
    
    int position3 = (int)[handle offsetInFile];
    DDLog(@"结束位置3: %d", position3);
    
    [handle writeData:[@"人" dataUsingEncoding:NSUnicodeStringEncoding]];
    
    [handle truncateFileAtOffset:18];  ///< @attention 如果这里截取的位置＞当前的结束符，然后继续写入，会从现读出来的时候，虽然读到了，但是因为带有'\0',而不会被NSLog或者print显示出来！！！(可能是他们的结束符)
    int position4 = (int)[handle offsetInFile];
    DDLog(@"结束位置4: %d", position4);
    
    [handle writeData:[@"test" dataUsingEncoding:NSUnicodeStringEncoding]];
    int position5 = (int)[handle offsetInFile];
    DDLog(@"结束位置5: %d", position5);
    
    [handle synchronizeFile];
    
    
    /* Writing Handle不能读取数据！！！！ */
    /*
    [handle seekToFileOffset:0];
    NSData *txtData = [handle readDataToEndOfFile];
    NSString *txt = [[NSString alloc] initWithData:txtData encoding:NSUnicodeStringEncoding];
    DDLog(@"读到的数据是 %@", txt);
    NSLog(@"%@", txt);
    */
    
    [handle closeFile];

}

/// 手机剩余的空间 （单位：MB）
+ (double)freeDiskSpaceInBytes{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace/1024.0/1024;
}
@end
