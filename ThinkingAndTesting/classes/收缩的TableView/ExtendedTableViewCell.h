//
//  ExtendedTableViewCell.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtendedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView ;

@end
