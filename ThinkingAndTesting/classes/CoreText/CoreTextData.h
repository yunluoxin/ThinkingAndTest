//
//  CoreTextData.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

/**
 *
 */
@property (assign , nonatomic) CTFrameRef frameRef ;

/**
 *  
 */
@property (assign , nonatomic)CGFloat textHeight ;

/**
 *  <#note#>
 */
@property (nonatomic, strong)NSMutableArray * imageArray ;
@end

@interface CoreTextImageData : NSObject

/**
 *  占位文字的位置
 */
@property (assign , nonatomic)NSInteger position ;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString * imageName ;

/**
 *  图片的位置
 */
@property (assign , nonatomic)CGRect imageRect ;

@end
