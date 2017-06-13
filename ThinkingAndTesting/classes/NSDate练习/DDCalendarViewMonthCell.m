//
//  DDCalendarViewMonthCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDCalendarViewMonthCell.h"
#import "DDCalendarViewDayCell.h"

static NSString * identifier = @"emptyCell" ;

@interface DDCalendarViewMonthCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DDCalendarViewMonthCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(DDCalendarViewDayCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(DDCalendarViewDayCell.class)] ;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier] ;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 7 ;
    CGFloat height = 35 ;
    self.flowLayout.itemSize = CGSizeMake(width, height) ;
    self.flowLayout.minimumLineSpacing = 0 ;
    self.flowLayout.minimumInteritemSpacing = 0 ;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCalendarDayItem * firstItem = self.monthItem.items.firstObject ;
    
    if (indexPath.row < (firstItem.weekday - 1) || indexPath.row > (self.monthItem.items.count + firstItem.weekday - 2)) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath] ;
    }else{
        DDCalendarViewDayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(DDCalendarViewDayCell.class) forIndexPath:indexPath] ;
        DDCalendarDayItem * dayItem = self.monthItem.items[indexPath.row - (firstItem.weekday - 1)] ;
        cell.dayItem = dayItem ;
        return cell ;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCalendarDayItem * firstItem = self.monthItem.items.firstObject ;
    if (indexPath.row < (firstItem.weekday - 1) || indexPath.row > (self.monthItem.items.count + firstItem.weekday - 2)) {
        return ;
    }
    
    DDCalendarDayItem * dayItem = self.monthItem.items[indexPath.row - (firstItem.weekday - 1)] ;
    dayItem.selected = YES ;
    
    if (self.whenSelectAtIndex) {
        self.whenSelectAtIndex(self, dayItem, indexPath.row) ;
    }
}


- (void)setMonthItem:(DDCalendarMonthItem *)monthItem
{
    _monthItem = monthItem ;
    
    [self.collectionView reloadData] ;
}
@end
