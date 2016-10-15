//
//  DDFormCell.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormItem.h"

@interface DDFormCell : UITableViewCell <DDFormProtocol>

@property (nonatomic, strong) FormItem * item ;

/**
 *  便利的构造方法
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
