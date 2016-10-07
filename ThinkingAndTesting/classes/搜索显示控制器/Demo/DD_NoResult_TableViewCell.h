//
//  DD_NoResult_TableViewCell.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DD_NoResult_TableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView ;

/**
 *  提示的文字
 */
@property (nonatomic, copy) NSString * tip ;
@end
