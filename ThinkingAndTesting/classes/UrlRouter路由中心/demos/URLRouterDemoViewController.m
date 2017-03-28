//
//  URLRouterDemoViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "URLRouterDemoViewController.h"

#import "DDUrlRouter.h"

#import "URRequest.h"

@interface URLRouterDemoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView ;

@end

@implementation URLRouterDemoViewController

#pragma mark - life cycle

- (instancetype)init
{
    if (self = [super init]) {
        // init some datas
    }
    return self ;
}

- (void)dealloc
{
    DDLog(@"%s",__func__) ;
}


#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"URLRouter Demo" ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    URRequest * request = [URRequest requestWithUrl:@"http://www.kachemama.com/mobile/home/data;sessionId=324232332?a=b&c=d" withType:URRequestTypeWeb] ;
    
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"" ;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"" ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellIdentifier" ;
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID ] ;
        cell.textLabel.font = [UIFont systemFontOfSize:17] ;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11] ;
        cell.detailTextLabel.textColor = [UIColor orangeColor] ;
    }
    return cell ;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
    
}



#pragma mark - actions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UIViewController * vc = [DDUrlRouter viewControllerWithUrlFromNative:@"cart/list?word=baidu"] ;
//        UIViewController * vc = [DDUrlRouter viewControllerWithUrlFromNative:URPageAPageKey] ;
    
    __weak typeof(self) weakSelf = self ;
    void (^whenPopVC)(id) = ^(id value){
        weakSelf.view.backgroundColor = RandomColor ;
    };
    
    UIViewController * vc = [DDUrlRouter viewControllerWithUrlFromNative:URPageAPageKey params:@{
                                                                                                 @"image":[UIImage imageWithColor:[UIColor purpleColor]],
                                                                                                 @"whenPopVC":[whenPopVC copy]
                                                                                                 }] ;
    [self.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - private methods



#pragma mark - getter and setter



@end
