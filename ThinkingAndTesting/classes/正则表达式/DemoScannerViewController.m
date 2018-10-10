//
//  DemoScannerViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/9.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "DemoScannerViewController.h"

#import <objc/runtime.h>

@interface DemoScannerViewController ()

@end

@implementation DemoScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ///
    /// 如何知道传进来的参数是否是类对象（xx.class）?
    /// 可以用下面的方法：通过判断 参数的class是否是元类，如果是，则之前传的就是类！
    ///
    BOOL result = class_isMetaClass(object_getClass(NSObject.class));
    NSLog(@"NSObject.class is meta class: %d", result);
    
    [self test];
}


/**
 NSScanner的使用
 
 @attention 如果[scanner scanxxx]时候没扫描到需要的，游标位置不会走！永远就不会atEnd! 要防止通过while (!scanner.isAtEnd)的死循环
 */
- (void)test {
    NSScanner *scanner = [NSScanner scannerWithString:@"what you^_^said is wrong!  good bye"];
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"^_^!"];
    NSString *result;
    NSLog(@"%li", scanner.scanLocation);
    [scanner scanString:@"w" intoString:&result];
    NSLog(@"%@", result);
    NSLog(@"%li", scanner.scanLocation);
    
    [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"] intoString:&result];
    NSLog(@"%@", result);
    
    while (!scanner.isAtEnd) {
        [scanner scanString:@" " intoString:NULL];  // 这句话等于 扫描一个空格，游标位置加1，不保存结果
        
        ///
        /// 从刚刚提供的字符串里面，扫描出set里面的字符,直到不是里面的字符
        ///
        [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"] intoString:&result];
        if (result) {
            NSLog(@"%@", result);
            result = nil;
        }
    }

    
    scanner = [NSScanner scannerWithString:@"what's your name!"];
    ///
    /// 从刚刚提供的字符串里面，扫描到set里面的字符就停下
    ///
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ah"] intoString:&result]; // wh
    
    NSLog(@"%@",result);
}

@end
