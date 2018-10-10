//
//  main.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/1/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define inc(i) do { int a = 0; ++i; } while(0)

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        char * a = "dsaf" ;
//        char * b ;
//        b = a ;
//        NSLog(@"%p, %p, %p, %p", a, b, &a, &b) ;
        
        ///
        /// Objective-C 不是卫生宏，调用inc(a),会直接替换展开为 =>  do { int a = 0; ++a; } while(0) ，导致局部变量a会屏蔽外层的a，++a操作的是局部变量里的a，不影响里面的
        ///
        int a = 4, b = 8;
        inc(a);
        inc(b);
        printf("%d, %d\n", a, b);   // 4, 9 !!!
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
