//
//  InfoShowScrollView.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoShowScrollView : UITableView

@property (nonatomic, strong) NSMutableArray <NSAttributedString *> * infos ;

/**
    每次可见的信息个数，一屏显示个数
 */
@property (nonatomic, assign) NSInteger visibleCellCountEveryTime ;

@property (nonatomic, copy) void (^whenClickAtRow)(NSUInteger row) ;

@end
