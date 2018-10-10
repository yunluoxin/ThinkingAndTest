//
//  YYModelViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/10.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import "YYModelViewController.h"

#import "HomePageService.h"
#import "HomeBanner.h"

#import "YYModel.h"

@interface YYModelViewController ()

@end

@implementation YYModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [HomePageService loadHomeBannerListWithCompleteHandler:^(id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"loading success");
            NSLog(@"%@",[responseObject class]);    // __NSArrayM
            
            // 数组对象 -> json字符串
            NSLog(@"\n\n\n convert to json string");
            NSLog(@"%@",[responseObject yy_modelToJSONString]);
            
            // 数组对象 -> 字典
            NSLog(@"\n\n\n try to conver to json object");
            NSLog(@"%@",[responseObject yy_modelToJSONObject]);
            
            // 单个对象 ->
            HomeBanner *banner = [(NSArray *)responseObject objectAtIndex:0];
            NSLog(@"%@", banner);
            NSLog(@"%@", [banner yy_modelToJSONString]);
            NSLog(@"%@", [banner yy_modelToJSONObject]);
            
            // Set ->
            NSSet *itemSet = [NSSet setWithArray:responseObject];
            NSLog(@"%@", itemSet);
            NSLog(@"%@", [itemSet yy_modelToJSONString]);
            NSLog(@"%@", [itemSet yy_modelToJSONObject]);
        }
    }];
}
@end
