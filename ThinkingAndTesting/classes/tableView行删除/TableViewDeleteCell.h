//
//  TableViewDeleteCell.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/8/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteModel.h"
@interface TableViewDeleteCell : UITableViewCell

@property (nonatomic, copy) void (^whenDeleteBtnClicked)(DeleteModel * m) ;
@property (nonatomic, strong)DeleteModel *  model ;
+(instancetype)cellWithTableView:(UITableView *)tableView ;

@end
