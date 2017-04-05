//
//  AuthDataBuilder.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "AuthDataBuilder.h"
#import "DDAuthCellConfig.h"

static NSString * const SpecialKey = @"SpecialKey" ;

@implementation AuthDataBuilder

+ (NSArray<DDBaseCellConfig *> *)buildDataFrom:(DriverAuthorizedForm *)form
{
    NSMutableArray * configs = @[].mutableCopy ;
    
    CGFloat height = 80 ;
    
    /// 上半身照
    NSMutableArray * realValue = @[
                                   form.photo?:@""
                                   ].mutableCopy ;
    NSMutableArray * tempValue = @[
                                   [AuthCellImageItemConfig configWithIsTemplate:NO selectedImage:[UIImage imageNamed:form.photo] templatedImage:[UIImage imageNamed:@"ali"]],
                                   [AuthCellImageItemConfig configWithIsTemplate:YES selectedImage:[UIImage imageNamed:form.photo] templatedImage:[UIImage imageNamed:@"ali"]],
                                   ].mutableCopy ;
    [configs addObject:[DDBaseCellConfig configWithTitle:@"上半身照片" propertyName:@"photo" realValue:realValue tempValue:tempValue cellType:@1 cellIdentifier:nil cellHeight:height originalData:form]] ;
    
    
    /// 正反两面照
    realValue = @[
                   form.idFace?:@"",
                   form.idBack?:@"",
                   ].mutableCopy ;
    tempValue = @[
                   [AuthCellImageItemConfig configWithIsTemplate:NO selectedImage:[UIImage imageNamed:form.idFace] templatedImage:[UIImage imageNamed:@"ali"]],
                   [AuthCellImageItemConfig configWithIsTemplate:NO selectedImage:[UIImage imageNamed:form.idBack] templatedImage:[UIImage imageNamed:@"ali"]],
                   [AuthCellImageItemConfig configWithIsTemplate:YES selectedImage:[UIImage imageNamed:form.photo] templatedImage:[UIImage imageNamed:@"ali"]],
                   [AuthCellImageItemConfig configWithIsTemplate:YES selectedImage:[UIImage imageNamed:form.photo] templatedImage:[UIImage imageNamed:@"ali"]],
                   ].mutableCopy ;
    [configs addObject:[DDBaseCellConfig configWithTitle:@"正反两面照" propertyName:SpecialKey realValue:realValue tempValue:tempValue cellType:@1 cellIdentifier:nil cellHeight:height originalData:form]] ;
    
    
    /// 驾驶证
    realValue = @[
                  form.driverLicense?:@""
                  ].mutableCopy ;
    tempValue = @[
                  [AuthCellImageItemConfig configWithIsTemplate:NO selectedImage:[UIImage imageNamed:form.driverLicense] templatedImage:[UIImage imageNamed:@"ali"]],
                  [AuthCellImageItemConfig configWithIsTemplate:YES selectedImage:[UIImage imageNamed:form.photo] templatedImage:[UIImage imageNamed:@"ali"]],
                  ].mutableCopy ;
    [configs addObject:[DDBaseCellConfig configWithTitle:@"驾驶证" propertyName:@"driverLicense" realValue:realValue tempValue:tempValue cellType:@1 cellIdentifier:nil cellHeight:height originalData:form]] ;
    
    
    /// 行驶证
    realValue = @[
                  form.drivingLicense?:@""
                  ].mutableCopy ;
    tempValue = @[
                  [AuthCellImageItemConfig configWithIsTemplate:NO selectedImage:[UIImage imageNamed:form.drivingLicense] templatedImage:[UIImage imageNamed:@"ali"]],
                  [AuthCellImageItemConfig configWithIsTemplate:YES selectedImage:[UIImage imageNamed:form.photo] templatedImage:[UIImage imageNamed:@"ali"]],
                  ].mutableCopy ;
    [configs addObject:[DDBaseCellConfig configWithTitle:@"行驶证" propertyName:@"drivingLicense" realValue:realValue tempValue:tempValue cellType:@1 cellIdentifier:nil cellHeight:height originalData:form]] ;
    
    return configs ;
}

+ (void)composeForm:(DriverAuthorizedForm *)form withConfigs:(NSArray *)configs
{
    for (DDAuthCellConfig * config in configs) {
        switch (config.cellType.intValue) {
            case 1:
            {
                if ([config.propertyName isEqualToString:SpecialKey]) {
                    form.idFace = [(AuthCellImageItemConfig *)[(NSArray *)config.stagingValue objectAtIndex:0] imageUrl] ;
                    form.idBack = [(AuthCellImageItemConfig *)[(NSArray *)config.stagingValue objectAtIndex:1] imageUrl] ;
                    continue ;
                }
                
                NSMutableArray * arrayM = @[].mutableCopy ;
                for (AuthCellImageItemConfig * c in (NSArray *)config.stagingValue) {
                    
                    if (!c.isTemlate && c.imageUrl) {
                        [arrayM addObject:c.imageUrl] ;
                    }
                }
                NSString * urls = [arrayM componentsJoinedByString:@","];
                config.obj = urls ;
                break;
            }
            default:
                break;
        }
        
        [form setValue:config.obj forKey:config.propertyName] ;
    }
}


+ (NSString *)vaildDatas:(NSArray * )configs
{
    for (DDAuthCellConfig * config in configs) {
        switch (config.cellType.intValue) {
            case 1:
            {
                if ([config.propertyName isEqualToString:SpecialKey]) {
                    NSString * idFace = [(AuthCellImageItemConfig *)[(NSArray *)config.stagingValue objectAtIndex:0] imageUrl] ;
                    NSString * idBack = [(AuthCellImageItemConfig *)[(NSArray *)config.stagingValue objectAtIndex:1] imageUrl] ;
                    if (!idFace) return @"正面照不能为空" ;
                    if (!idBack) return @"负面照不能为空" ;
                    continue ;
                }
                
                NSMutableArray * arrayM = @[].mutableCopy ;
                for (AuthCellImageItemConfig * c in (NSArray *)config.stagingValue) {
                    
                    if (!c.isTemlate && c.imageUrl) {
                        [arrayM addObject:c.imageUrl] ;
                    }
                }
                NSString * urls = [arrayM componentsJoinedByString:@","];
                config.obj = urls ;
                break;
            }
            default:
                break;
        }
        
        if (config.obj) {
            return nil ;
        }else{
            return [NSString stringWithFormat:@"%@有未填项目",config.title] ;
        }
    }
    
    return nil ;
}

@end
