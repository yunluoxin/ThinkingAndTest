//
//  DDBaseCell.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDBaseCellItem.h"

@class DDBaseCell ;

@protocol DDBaseCellProtocol <NSObject>

@required
+ (instancetype)cellWithTableView:(UITableView *)tableView ;

@optional
- (void)configureCell:(DDBaseCell *)cell withData:(DDBaseCellItem *)item ;

@end

@interface DDBaseCell : UITableViewCell

@property (strong, nonatomic)DDBaseCellItem * item ;

@end
