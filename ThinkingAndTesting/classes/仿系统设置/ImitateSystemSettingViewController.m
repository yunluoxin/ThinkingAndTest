//
//  ImitateSystemSettingViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/5.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ImitateSystemSettingViewController.h"

@interface ImitateSystemSettingViewController ()

@end

@implementation ImitateSystemSettingViewController

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self ;
}

- (void)dealloc
{
    NSLog(@"%s",__func__) ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"ImitateSystemSettingViewController" ;
    
    self.view.backgroundColor = [UIColor greenColor] ;
    
    
}




#pragma mark - actions


#pragma mark - private methods
- (void)p_anylysePlistFile
{
    
    /// 读取到的源数据，是一个数组
    NSArray * array = @[] ;
    
    /// 转换后的数据 数组
    NSMutableArray * groups = @[].mutableCopy ;
    
    /// 某个group
    NSMutableDictionary * group = nil ;
    
    /// group里面的cell
    NSMutableArray * items = nil ;
    
    for (int i = 0 ; i < array.count; i ++) {
        NSDictionary * dic = array[i] ;
        
        /// 如果是组类型，就新建一个组
        if ([dic[@"type"] isEqualToString: @"GROUP"]) {
            group = @[].mutableCopy ;
            items = @[].mutableCopy ;
            [group setObject:items forKey:@"items"] ;
            [group setObject:dic[@"title"] forKey:@"title"] ;
            [groups addObject:group] ;
        }
        else        /// 其他时候， 就添加item
        {
            [items addObject:dic] ;
        }
    }
}

@end
