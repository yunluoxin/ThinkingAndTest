//
//  TestEnum2.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TestEnum2.h"

@implementation TestEnum2

@end


NSString *  const SaleStatusValue[] ={
    // @"取消",
    [kSTATUS_SALE_NEW] = @"新订单",
    [kSTATUS_SALEA_WAIT] = @"等待支付",
    [kSTATUS_SALEB_PAYED] = @"已付款",
    [kSTATUS_SALEC_PRODUCING] = @"生产中",
    [kSTATUS_SALED_PRODUCED] = @"已生产",
    [kSTATUS_SALEE_DELIVERING] = @"已发货",
    [kSTATUS_SALEF_RECEIVED] = @"已签收",
    [kSTATUS_SALEG_COMPLATED] = @"已完成",
};

NSString *  const SaleStatusName[] ={
    // @"取消",
    [kSTATUS_SALE_NEW] = @"kSTATUS_SALE_NEW",
    [kSTATUS_SALEA_WAIT] = @"kSTATUS_SALEA_WAIT",
    [kSTATUS_SALEB_PAYED] = @"已付款",
    [kSTATUS_SALEC_PRODUCING] = @"生产中",
    [kSTATUS_SALED_PRODUCED] = @"已生产",
    [kSTATUS_SALEE_DELIVERING] = @"已发货",
    [kSTATUS_SALEF_RECEIVED] = @"已签收",
    [kSTATUS_SALEG_COMPLATED] = @"已完成",
};
