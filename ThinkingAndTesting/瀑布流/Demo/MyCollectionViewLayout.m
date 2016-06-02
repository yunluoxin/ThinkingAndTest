//
//  MyCollectionViewLayout.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "MyCollectionViewLayout.h"

@interface MyCollectionViewLayout()

@property (nonatomic, strong) NSMutableArray *layoutAttributesArray ;
@property (nonatomic, strong) NSMutableDictionary<NSNumber * , NSNumber *> * dicOfHeight ;   //存储每一列当前的高度

@end

@implementation MyCollectionViewLayout


- (instancetype)init
{
    if (self = [super init]) {
        
        self.spacing = 8 ;
        self.interSpacing = 8 ;
        self.colNumber = 3 ;
        self.sectionEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.layoutAttributesArray = [NSMutableArray array];
        self.dicOfHeight = [NSMutableDictionary dictionary];
        
    }
    return self ;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始化列高
    for (int i = 0 ; i < self.colNumber;  i ++) {
        _dicOfHeight[@(i)] = @(self.sectionEdgeInset.top);
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0 ; i < count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.layoutAttributesArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat width = (self.collectionView.dd_width - self.sectionEdgeInset.left - self.sectionEdgeInset.right - (self.colNumber - 1 ) * self.spacing ) / self.colNumber ;
    
    CGFloat height = 0 ;
    if (self.heightForCell) {
        height = self.heightForCell(indexPath, width);
    }else{
        NSAssert(height != 0, @"请赋值一个高度计算的代码" );
    }
    
    CGRect frame ;
    frame.size = CGSizeMake(width, height);
    
    //循环计算出最矮的那行
    __block NSNumber *minCol = @0 ;
    [self.dicOfHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([_dicOfHeight[minCol] floatValue] > [_dicOfHeight[key] floatValue]) {
            minCol = key ;
        }
    }];
    
    CGFloat minHeight = [_dicOfHeight[minCol] floatValue] ;
    CGFloat x = self.sectionEdgeInset.left + minCol.integerValue * (self.spacing + width) ;
    CGFloat y = minHeight ;
    frame.origin.x = x ;
    frame.origin.y = y ;
    
    //更新列高
    self.dicOfHeight[minCol] = @(y + height + self.interSpacing) ; //这里把行间隔算在一个块计算之后
    
    layoutAttr.frame = frame ;
    
    return layoutAttr ;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layoutAttributesArray ;
}

- (CGSize)collectionViewContentSize
{
    //计算出最高的那行
    __block NSNumber * maxCol = 0 ;
    [self.dicOfHeight enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([_dicOfHeight[maxCol] floatValue] < [_dicOfHeight[key] floatValue]) {
            maxCol = key ;
        }
    }];
    
    CGFloat maxHeight = [_dicOfHeight[maxCol] floatValue];
    
    CGFloat h = maxHeight + self.sectionEdgeInset.bottom ;
    CGFloat w = self.collectionView.dd_width ;
    
    return CGSizeMake(w, h);
}
@end
