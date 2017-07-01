//
//  StructSerializationViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/15.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "StructSerializationViewController.h"

typedef struct{
    char name ;
    int age ;
    double money ;
}TestStruct;

@interface StructSerializationViewController ()

@end

@implementation StructSerializationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestStruct test ;
    test.age = 1 ;
    test.money = 5.0f ;
    test.name = 'A' ;
    
    NSValue * value = [NSValue value:&test withObjCType:@encode(TestStruct)] ;
    DDLog(@"%@",value) ;
    
    
    // XXX 不行！都无法实现 XXX
    //
    // NSKeyedArchiver无法压缩自定义结构体！！！
    // NSUserDefaults不支持存储NSValue!(哪怕是CGSize的)
    //
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:value] ;
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"test"] ;
    

    
    NSValue * value2 = [NSValue valueWithCGSize:CGSizeMake(50, 230)] ;
    NSData * data2 = [NSKeyedArchiver archivedDataWithRootObject:value2] ;
    [[NSUserDefaults standardUserDefaults] setObject:data2 forKey:@"test"] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"test"] ;
    NSValue * value = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
    DDLog(@"%@",value) ;
    TestStruct  theTestStruct;
    [value getValue:&theTestStruct];
    
    ; ;
    
}

@end
