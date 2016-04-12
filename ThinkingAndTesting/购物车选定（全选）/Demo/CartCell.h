//
//  CartCell.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/5.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell
/**
 *  是否被选中
 */
@property (nonatomic, assign) BOOL mark ;

@property (nonatomic, copy) void (^whenMarked)(BOOL mark);

+ (instancetype)cellWithTableView:(UITableView  *)tableView ;
@end
