//
//  TestEnum2.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestEnum2 : NSObject

@end

typedef NS_ENUM(NSUInteger, SaleStatus){
    //取消
    // kSTATUS_SALE_CANLE = -1,
    
    /**
     * 新订单
     */
    kSTATUS_SALE_NEW = 0,
    /**
     * 等待支付
     */
    kSTATUS_SALEA_WAIT,
    /**
     * 已付款
     */
    kSTATUS_SALEB_PAYED,
    
#warning 以上状态未使用
    
    /**
     * 生产中
     */
    kSTATUS_SALEC_PRODUCING,
    /**
     * 已生产
     */
    kSTATUS_SALED_PRODUCED,
    /**
     * 已发货
     */
    kSTATUS_SALEE_DELIVERING,
    /**
     * 已签收
     */
    kSTATUS_SALEF_RECEIVED,
    /**
     * 已完成
     */
    kSTATUS_SALEG_COMPLATED,
    
};

FOUNDATION_EXPORT NSString * const SaleStatusValue[] ;
