//
//  BoxEntity.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DynamicBoxBlock)();

@interface BoxEntity : NSObject

@property (nonatomic, copy) NSString * title ;
@property (nonatomic, copy) NSString * imageName ;
@property (nonatomic, copy) DynamicBoxBlock whenTapCell ;

@end
