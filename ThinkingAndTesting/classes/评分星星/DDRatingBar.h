//
//  DDRatingBar.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDRatingBarMode){
    DDRatingBarReadOnlyMode,    //只读模式，显示星星值
    DDRatingBarNormalMode       //正常模式，可以评价
};

@interface DDRatingBar : UIView
/**
 *  星星的数量
 */
@property (nonatomic, assign) NSUInteger numberOfStars ;
/**
 *  当前评分值
 */
@property (nonatomic, assign) NSUInteger currentRating ;
/**
 *  当前的模式：只读/可评分
 */
@property (nonatomic, assign) DDRatingBarMode     mode ;

@end
