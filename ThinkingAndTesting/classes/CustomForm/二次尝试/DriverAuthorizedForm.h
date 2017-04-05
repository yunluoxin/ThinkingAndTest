//
//  DriverAuthorizedForm.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverAuthorizedForm : NSObject
/**
 *  身份证正面照
 */
@property (nonatomic, copy)NSString * idFace ;

/**
 *  身份证反面照
 */
@property (nonatomic, copy)NSString * idBack ;
/**
 *  手持身份证照片
 */
@property (nonatomic, copy)NSString * photo ;
/**
 *  驾驶证
 */
@property (nonatomic, copy)NSString * driverLicense ;
/**
 *  行驶证
 */
@property (nonatomic, copy)NSString * drivingLicense ;
/**
 *  真实姓名
 */
@property (nonatomic, copy)NSString * realName ;
/**
 *  车牌号
 */
@property (nonatomic, copy)NSString * plateNo ;
/**
 *  品牌名称，格式跟发布车源一致
 */
@property (nonatomic, copy)NSString * brand ;
/**
 *  品牌LOGO地址，格式跟发布车源一致
 */
@property (nonatomic, copy)NSString * brandLogo ;
/**
 *  车型编号，格式跟发布车源一致
 */
@property (nonatomic, copy)NSString * carTypeCode ;
/**
 *  车长，格式跟发布车源一致
 */
@property (nonatomic, copy)NSString * carLength ;
/**
 *  载重量，格式跟发布车源一致
 */
@property (nonatomic, copy)NSString * weight ;

- (instancetype)initWithFace:(NSString *)idFace back:(NSString *)idBack photo:(NSString *)photo driverLicense:(NSString *)driverLicense drivingLicense:(NSString *)drivingLicense ;

@end
