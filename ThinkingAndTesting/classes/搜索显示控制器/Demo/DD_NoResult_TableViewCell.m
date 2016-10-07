//
//  DD_NoResult_TableViewCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/3/16.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DD_NoResult_TableViewCell.h"

static NSString *ID = @"DD_NoResult_TableViewCell" ;

@interface DD_NoResult_TableViewCell()
/**
 *  居中的图片
 */
@property (nonatomic, weak)UIImageView *imageV ;
/**
 *  提示的文字
 */
@property (nonatomic, weak)UILabel *tipLabel ;
@end

@implementation DD_NoResult_TableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    DD_NoResult_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell initView];
    }
    return cell ;
}

- (void)initView {
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_search"]];
    _imageV = imageV ;
    [self.contentView addSubview:imageV];
    CGFloat y = 100 ;
    imageV.center = CGPointMake(DD_SCREEN_WIDTH/2,y );
    
    UILabel *label = [[UILabel alloc]init];
    _tipLabel = label ;
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0 ;
    label.text = @"很抱歉，暂无记录" ;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter ;
    label.frame = CGRectMake(0, _imageV.dd_bottom + 8, DD_SCREEN_WIDTH, 44);
    [self.contentView addSubview:label];
}

- (void)setTip:(NSString *)tip
{
    _tip = tip ;
    self.tipLabel.text = tip ;
    if (tip) {
        CGSize size = [tip sizeOfFont:[UIFont systemFontOfSize:15] maxWidth:DD_SCREEN_WIDTH/2 maxHeight:100];
        CGFloat x = (DD_SCREEN_WIDTH - size.width)/2 ;
        CGFloat y = _tipLabel.dd_top ;
        _tipLabel.frame = CGRectMake(x, y, size.width, size.height);
    }
}
@end
