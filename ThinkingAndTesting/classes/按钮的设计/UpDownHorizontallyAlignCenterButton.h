//
//  UpDownHorizontallyAlignCenterButton.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/10/16.
//  Copyright © 2018年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 图片在上，文字在下，水平居中的Button
 */
IB_DESIGNABLE
@interface UpDownHorizontallyAlignCenterButton : UIButton

///
/// 图片配置
///
@property (assign, nonatomic) IBInspectable CGSize imageSize;         ///< 图片的大小
@property (assign, nonatomic) IBInspectable float imageWidth;         ///< 如果宽高相等，可直接设置这个
@property (assign, nonatomic) IBInspectable float imageMarginTop;    ///< 图片的上边距
@property (assign, nonatomic) IBInspectable float imageMarginBottom; ///< 图片的下边距, 优先级低于marginTop. 只有marginTop <= 0或者imageWidth <= 0时候，才生效

///
/// 文字配置
///
@property (assign, nonatomic) IBInspectable float titleMarginBottom;
@property (assign, nonatomic) IBInspectable float titleMarginTop;
@end
