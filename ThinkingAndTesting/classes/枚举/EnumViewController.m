//
//  EnumViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "EnumViewController.h"
#import "TestEnum.h"
#import "TestEnum2.h"
#import "TestEnum3.h"

@interface EnumViewController ()

@end

@implementation EnumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    DDLog(@"%@",[testEnum sharedInstance].test1) ;
    DDLog(@"%@",[testEnum sharedInstance].test2) ;
     DDLog(@"%@",[testEnum sharedInstance].test1) ;
     DDLog(@"%d",[[testEnum sharedInstance].test1 isEqual:[testEnum sharedInstance].test2] ) ;
    
    NSLog(@"%@",SaleStatusValue[kSTATUS_SALE_NEW]) ;
    
    NSString * path  = [[NSBundle mainBundle] pathForResource:@"order" ofType:@"json"] ;
//
//    NSString * str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] ;
//    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding] ;
    
    NSData * data = [NSData dataWithContentsOfFile:path] ;
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil] ;
    DDLog(@"%@",dic[@"SaleMan"] );
    
    
    [self getByStatus:OrderStatusDelived] ;
    
    [self getByKey:DDPropertyAttributeName] ;
}

- (void)getByStatus:(OrderStatus)orderStatus
{
    
}


- (void)getByKey:(DDPropertyKey)key
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
