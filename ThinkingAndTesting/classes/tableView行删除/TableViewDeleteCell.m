//
//  TableViewDeleteCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/8/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "TableViewDeleteCell.h"

static NSString * ID = @"TableViewDeleteCell" ;

@interface TableViewDeleteCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end


@implementation TableViewDeleteCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    TableViewDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil]firstObject];
    }
    return cell ;
}

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (IBAction)didDeleteBtnClicked:(UIButton *)sender {
    if (self.whenDeleteBtnClicked) {
        self.whenDeleteBtnClicked() ;
    }
}

@end
