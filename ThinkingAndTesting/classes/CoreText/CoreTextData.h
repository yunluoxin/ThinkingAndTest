//
//  CoreTextData.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/3/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@class CoreTextLinkData ;

@interface CoreTextData : NSObject

/**
 *
 */
@property (assign , nonatomic) CTFrameRef frameRef ;

/**
 *  the height of frameRef, it would be suggested height of the view which owns this data.
 */
@property (assign , nonatomic)CGFloat textHeight ;

/**
 *  the image datas in this frameRef
 */
@property (nonatomic, strong)NSMutableArray * imageArray ;

/**
 *  the link datas in this frameRef
 */
@property (nonatomic, strong)NSMutableArray * linkArray ;


/**
 according to the given touched point, find which link in array(links) in touched.

 @param touchPoint
 @param links all the links we have registerd and saved.
 @param frameRef frameRef
 @return which link is touched
 */
+ (CoreTextLinkData *)findLinkOnTouchedPoint:(CGPoint)touchPoint inLinkArray:(NSArray *)links ofFrameRef:(CTFrameRef)frameRef ;

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




@interface CoreTextLinkData : NSObject

/**
 *  <#note#>
 */
@property (nonatomic, copy) NSString * url ;

/**
 *  <#note#>
 */
@property (nonatomic, copy) NSString * title ;

/**
 *  <#note#>
 */
@property (assign , nonatomic)NSRange range ;
@end
