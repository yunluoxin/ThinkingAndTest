//
//  ElasticityCell.m
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/11/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ElasticityCell.h"


@interface ElasticityCell ()

@property (nonatomic, strong) ElasticityLayoutView * layoutView ;
@end

@implementation ElasticityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"adsfasdf" ;
    ElasticityCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    return cell ;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.layoutView = [[ElasticityLayoutView alloc] initWithFrame:CGRectMake(0, 0, self.dd_width, 85) ];
        [self.contentView addSubview:self.layoutView] ;
    }
    return self ;
}

- (void)setDatas:(NSArray<ElasticityEntity *> *)datas
{
    _datas = datas ;
    
    self.layoutView.datas = datas ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    self.layoutView.frame = self.contentView.bounds ;
}
@end
