//
//  CALayer+DD.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/17.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (DD)
/**-------layer的四个方位的快捷获取方法---------*/
@property (nonatomic, assign) CGFloat dd_height ;
@property (nonatomic, assign) CGFloat dd_width ;
@property (nonatomic, assign) CGFloat dd_left ;
@property (nonatomic, assign, readonly) CGFloat dd_right ;
@property (nonatomic, assign) CGFloat dd_top ;
@property (nonatomic, assign, readonly) CGFloat dd_bottom ;
/**----------------------------------------*/
@end
