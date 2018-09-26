//
//  CategoryTestViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/7/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "CategoryTestViewController.h"
#import "DDUtils+Test.h"
#import "MultiAnonymousExtension.h"


#define weak(obj) autoreleasepool{} __typeof(obj) __weak weak##obj = obj
#define strong(obj) autoreleasepool{} __typeof(weak##obj) __strong strong##obj = weak##obj


@interface CategoryTestViewController ()

@end

@implementation CategoryTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DDUtils kaoYa] ;
    
    MultiAnonymousExtension *m = [MultiAnonymousExtension new] ;
    [m test] ;
    [m print] ;
    
    @weak(self);
//    @strong(m) ;
    @weak(m) ;
    @strong(m) ;
    DDLog(@"%@",weakself) ;
    @strong(self) ;
    DDLog(@"%@",strongself) ;

//    @autoreleasepool{} __typeof(self) __weak weakself = self ;
}


@end
