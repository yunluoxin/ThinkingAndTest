//
//  InfoShowCell.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoShowCell : UITableViewCell

@property (nonatomic, strong) NSAttributedString * content ;

+ (instancetype)cellWithTableView:(UITableView * )tableView ;
@end
