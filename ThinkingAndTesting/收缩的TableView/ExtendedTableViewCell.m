//
//  ExtendedTableViewCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ExtendedTableViewCell.h"

@interface ExtendedTableViewCell ()

@end

@implementation ExtendedTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"abc" ;
    ExtendedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ExtendedTableViewCell" owner:nil options:nil]lastObject];
    }
    return cell ;
}

@end
