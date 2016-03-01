//
//  DDTableViewCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.

/*  ========测试哪个在registerClass的时候会被自动执行=========

    - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier被执行
 
    style为 默认的「UITableViewCellStyleDefault」
    
    reuseIdentifier为注册时候写的文标识
 
 
    ========测试哪个在registerNib的时候会被自动执行=========
 
    - (void)awakeFromNib

*/
#import "DDTableViewCell.h"

@implementation DDTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        DDLog(@"initWithFrame:");
    }
    return self ;
}

- (void)awakeFromNib {
        DDLog(@"awakeFromNib");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        DDLog(@"---init:");
    }
    return self ;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        DDLog(@"initWithStyle:%ld, reuseIdentifier:%@",style,reuseIdentifier);
    }
    return self ;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
