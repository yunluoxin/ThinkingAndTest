//
//  TableViewDeleteCell.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/8/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewDeleteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, copy) void (^whenDeleteBtnClicked)() ;

+(instancetype)cellWithTableView:(UITableView *)tableView ;

@end
