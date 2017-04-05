//
//  DriverAuthorizedForm.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DriverAuthorizedForm.h"

@implementation DriverAuthorizedForm

- (instancetype)initWithFace:(NSString *)idFace back:(NSString *)idBack photo:(NSString *)photo driverLicense:(NSString *)driverLicense drivingLicense:(NSString *)drivingLicense
{
    if (self = [super init]) {
        self.idFace = idFace ;
        self.idBack = idBack ;
        self.photo = photo ;
        self.drivingLicense = drivingLicense ;
        self.driverLicense = driverLicense ;
    }
    return self ;
}

@end
