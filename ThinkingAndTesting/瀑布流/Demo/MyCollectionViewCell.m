//
//  MyCollectionViewCell.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        _label = label ;
        label.font = [UIFont systemFontOfSize:8];
        [self.contentView addSubview:label];
        
        self.contentView.backgroundColor = DDColor(arc4random() % 255, arc4random() % 255, arc4random() %255, 1);
    }
    return self ;
}
@end
