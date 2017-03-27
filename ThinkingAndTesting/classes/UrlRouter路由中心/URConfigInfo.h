//
//  URConfigInfo.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/27.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URConfigInfo : NSObject

/**
 *  对应的VC的名字
 */
@property (nonatomic, copy) NSString * vcName ;
/**
 *  无对应的VC后的降级页面地址
 */
@property (nonatomic, copy) NSString * h5PageUrl ;
/**
 *  最小的版本要求
 *  为0则表示无要求
 */
@property (nonatomic, copy) NSString * minVersion ;
/**
 *  是否需要登录
 */
@property (assign , nonatomic)BOOL loginNeed ;
/**
 *  是否禁止来自web的跳转要求
 */
@property (assign , nonatomic)BOOL forbidSourceWeb ;

- (instancetype)initWithDictionary:(NSDictionary *)dic ;

@end
