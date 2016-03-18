//
//  TabBarView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/18.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarView : UIView
/**
 *  当前选中的索引
 */
@property (nonatomic, assign) NSInteger currentIndex ;

@property (nonatomic, copy) void (^whenBtnClicked)(NSInteger index);

@end
