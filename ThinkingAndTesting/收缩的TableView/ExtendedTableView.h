//
//  ExtendedTableView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ExtendedTableViewDelegate <NSObject>

- (CGFloat)tableView:(UITableView *)tableView extendedHeightForRowAtIndexPath:(NSIndexPath *)indexPath ;

- (UITableViewCell *)tableView:(UITableView *)tableView extendedCellForRowAtIndexPath:(NSIndexPath *)indexPath ;

@end

@interface ExtendedTableView : UITableView

//将indexPath对应的row展开
- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated goToTop:(BOOL)goToTop;

//将展开的cell收起
- (void)shrinkCellWithAnimated:(BOOL)animated;

//查看传来的索引和当前被选中索引是否相同
- (BOOL)isEqualToSelectedIndexPath:(NSIndexPath *)selectedIndexPath ;

@end
