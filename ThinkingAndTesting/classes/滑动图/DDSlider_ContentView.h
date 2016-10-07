//
//  DDSlider_ContentView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/25.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSlider_ContentView : UIScrollView

@property (nonatomic, assign) NSUInteger stepToIndex ;

/**
 *  当滑动后位置改变的时候(实时变化，有小数)
 */
@property (nonatomic, copy) void (^whenPositionChanged)(CGFloat currentPosition) ;

/**
 *  当滚动停下来的时候（是整数的）
 */
@property (nonatomic, copy) void (^whenStopAtIndex)(NSUInteger index) ;

- (instancetype)initWithFrame:(CGRect)frame andContentViews:(NSArray <UIView *> *) contentViews ;
@end
