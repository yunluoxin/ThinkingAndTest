//
//  CyclePlayCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CyclePlayCell.h"

@implementation CycleEntity

@end



@interface CyclePlayCell()

@property (nonatomic, weak) UIImageView *imageV ;

@end

@implementation CyclePlayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        self.imageV = imageV ;
        [self.contentView addSubview:imageV];
        
    }
    return self ;
}

- (void)setEntity:(CycleEntity *)entity
{
    _entity = entity ;
    
    //图片地址加载图片
    self.contentView.backgroundColor = RandomColor;
}

@end

NSString * const CyclePlayCellIdentifier = @"CyclePlayCell" ;