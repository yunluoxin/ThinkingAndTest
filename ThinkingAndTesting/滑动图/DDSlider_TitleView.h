//
//  DDSlider_TitleView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSlider_TitleView : UIScrollView

@property (nonatomic, assign) CGFloat currentPosition ;

@property (nonatomic, assign) NSUInteger currentIndex ;

@property (nonatomic, copy) void (^whenClickAtIndex)(UIView *clickView, NSUInteger index) ;

/**
 *  构造方法
 *
 *  @param frame      frame
 *  @param titleViews 要放在titleView位置的views
 */
- (instancetype)initWithFrame:(CGRect)frame andTitleViews:(NSArray <UIView *> *) titleViews ;

@end
