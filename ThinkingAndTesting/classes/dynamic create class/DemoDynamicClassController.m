//
//  DemoDynamicClassController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/13.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoDynamicClassController.h"
#import "DynamicClass.h"
#import "AMethodObject.h"
@interface DemoDynamicClassController ()

@end

@implementation DemoDynamicClassController

- (void)viewDidLoad {
    [super viewDidLoad];

    Class clazz = [DynamicClass makeClassWithClassName:@"NewClass" extentsClass:[AMethodObject class]] ;
    id c = [clazz new] ;
    DDLog(@"%@",NSStringFromClass(clazz)) ;
    DDLog(@"%@",c) ;
    
    [c performSelector:@selector(abc) withObject:nil ] ;
    
    
    
    
    // oc --->  cf
    NSString *str = @"test cf __bridge__" ;
    CFStringRef p = (__bridge CFStringRef)str ;
//    printf("%s",(char *)p) ;
    NSLog(@"%@",(__bridge NSString *)p) ;
    
    
    //CF ----> OC
//    CFStringRef s = CFStringCreateWithCString(NULL, "test cf --> oc __bridge", NSUTF8StringEncoding) ;
//    NSString *s2 = (__bridge NSString *)s ;
//    NSLog(@"%@",s2) ;0520
    

    
    
    NSObject *obj = [NSObject new] ;
    void * k = (__bridge_retained void *)obj ;
    CFRelease(k) ;
    printf("%p",k) ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
