//
//  InfoShowCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "InfoShowCell.h"

@interface InfoShowCell ()

@property (nonatomic, strong) UILabel * infoLabel ;

@end

@implementation InfoShowCell

+ (instancetype)cellWithTableView:(UITableView * )tableView
{
    static NSString * InfoShowCellIdentifier = @"InfoShowCell" ;
    InfoShowCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoShowCellIdentifier] ;
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoShowCellIdentifier] ;
        [cell createUI] ;
    }
    return cell ;
}

- (void)createUI
{
    [self.contentView addSubview:self.infoLabel] ;
}

- (void)setContent:(NSAttributedString *)content
{
    _content = content ;
    
    self.infoLabel.attributedText = content ;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [UILabel new] ;
        _infoLabel.textColor = [UIColor blackColor] ;
        _infoLabel.backgroundColor = [UIColor whiteColor] ;
        _infoLabel.font = [UIFont systemFontOfSize:11] ;
        _infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _infoLabel.textAlignment = NSTextAlignmentLeft ;
    }
    return _infoLabel ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    self.infoLabel.frame = self.contentView.bounds ;
}

@end
