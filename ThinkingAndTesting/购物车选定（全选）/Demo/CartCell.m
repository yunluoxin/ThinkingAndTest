//
//  CartCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/5.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CartCell.h"

@interface CartCell()

@property (weak, nonatomic) IBOutlet UIButton *checkmarkBtn;

@end

@implementation CartCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CartCell";
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID] ;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil]lastObject];
        [cell initView];
    }
    return cell ;
}
- (void)initView
{
    
}
- (void)setMark:(BOOL)mark
{
    _mark = mark ;
    self.checkmarkBtn.selected = mark ;
}
- (IBAction)didCheckmarkBtnClicked:(UIButton *)sender {
    self.mark = !self.mark ;
    if (self.whenMarked) {
        self.whenMarked(self.mark);
    }
}

@end
