//
//  DDAuthCellConfig.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDBaseCellConfig.h"

@interface DDAuthCellConfig : DDBaseCellConfig

@end

@interface AuthCellImageItemConfig : NSObject
/**
 *  <#note#>
 */
@property (assign , nonatomic)bool isTemlate ;

/**
 *  <#note#>
 */
@property (nonatomic, strong)UIImage * templatedImage ;
/**
 *  <#note#>
 */
@property (nonatomic, strong)UIImage * selectedImage ;
/**
 *  上传后的图片url
 */
@property (nonatomic, copy) NSString * imageUrl ;
/**
 *  <#note#>
 */
@property (nonatomic, strong)UIImage * placeholderImage ;

+ (instancetype)configWithIsTemplate:(BOOL)isTemplate selectedImage:(UIImage *)selectedImage templatedImage:(UIImage *)templatedImage;

@end
