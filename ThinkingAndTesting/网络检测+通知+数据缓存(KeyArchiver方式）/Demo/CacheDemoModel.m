//
//  CacheDemoModel.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/24.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CacheDemoModel.h"

NSString *const DDGoodsDetailNotification = @"DDGoodsDetailNotification" ;

@implementation CacheDemoModel
- (void)getSomethingById:(NSString *)somethingId
{
//    [self url:@"http://localhost:8182/mobile/goods?goods_id=143" method:0 parameters:nil needLogin:YES fileName:[NSString stringWithFormat:@"%s",__FUNCTION__]notificationName:@"abc"];
//    [self url:@"http://localhost:8182/mobile/goods?goods_id=143" method:0 parameters:nil needLogin:YES notificationName:@"abc"];
    [self url:@"http://localhost:8182/mobile/goods?goods_id=143" method:0 parameters:nil needLogin:YES fileName:DDGoodsDetailNotification notificationName:DDGoodsDetailNotification];
}

//+ (NSString *)getSomethingById:(NSString *)somethingId
//{
//    CacheDemoModel *model = [[self alloc]init];
//    [model url:@"http://localhost:8182/mobile/goods?goods_id=143" method:0 parameters:nil needLogin:YES fileName:[NSString stringWithFormat:@"%s",__FUNCTION__] howToGetData:nil howToSaveData:nil];
//    return nil ;
//}
@end
