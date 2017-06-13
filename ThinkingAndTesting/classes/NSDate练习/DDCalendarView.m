//
//  DDCalendarView.m
//  ThinkingAndTesting
//
//  Created by dadong on 2017/6/13.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDCalendarView.h"
#import "DDCalendarMonthItem.h"
#import "DDCalendarViewDayCell.h"
#import "DDCalendarViewMonthCell.h"


@interface DDCalendarView ()
<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UIButton *currentYearMonthLabel;

/// 星期标志
@property (weak, nonatomic) IBOutlet UIView *weekFlagsView;

/**
 *  当前所在的月份
 */
@property (strong, nonatomic)DDCalendarDayItem * currentDayItem ;


@end

@implementation DDCalendarView
- (instancetype)initWithFrame:(CGRect)frame
{
    DDCalendarView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(DDCalendarView.class) owner:nil options:nil] lastObject] ;
    view.frame = frame ;
    return view ;
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(DDCalendarViewMonthCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(DDCalendarViewMonthCell.class)] ;

    
    CGFloat width = [UIScreen mainScreen].bounds.size.width ;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - self.weekFlagsView.dd_bottom ;
    self.flowLayout.itemSize = CGSizeMake(width, height) ;
    self.flowLayout.minimumLineSpacing = 0 ;
    self.flowLayout.minimumInteritemSpacing = 0 ;
}

- (IBAction)pressPreviousBtn:(id)sender
{
    CGFloat contentOffsetX = self.collectionView.contentOffset.x ;
    NSInteger index = contentOffsetX / self.collectionView.frame.size.width ;
    index -- ;
    if (index < 0) {
        index = 0 ;
    }
    [self p_scrollToIndex:index] ;
}

- (IBAction)pressNextBtn:(id)sender
{
    CGFloat contentOffsetX = self.collectionView.contentOffset.x ;
    NSInteger index = contentOffsetX / self.collectionView.frame.size.width ;
    index ++ ;
    if (index > self.monthItems.count - 1) {
        index = self.monthItems.count - 1 ;
    }
    [self p_scrollToIndex:index] ;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = self.collectionView.contentOffset.x ;
    NSInteger index = contentOffsetX / self.collectionView.frame.size.width ;
    [self p_scrollToIndex:index] ;
}



- (void)setMonthItems:(NSArray *)monthItems
{
    _monthItems = monthItems ;
    
    [self.collectionView reloadData] ;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.monthItems.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDCalendarViewMonthCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(DDCalendarViewMonthCell.class) forIndexPath:indexPath] ;
    cell.monthItem = self.monthItems[indexPath.row] ;

    __weak typeof(self) wself = self ;
    cell.whenSelectAtIndex = ^(DDCalendarViewMonthCell * c, DDCalendarDayItem * dayItem, NSInteger i) {
        [wself p_handleSelectedItem:dayItem] ;
        
        [wself.collectionView reloadData] ;
    } ;
    return cell ;
}

#pragma mark - private methods

- (void)p_scrollToIndex:(NSInteger)index
{
    [self.collectionView setContentOffset:CGPointMake(index * self.collectionView.frame.size.width, 0) animated:YES] ;
    DDCalendarMonthItem * item = self.monthItems[index] ;
    [self.currentYearMonthLabel setTitle:[NSString stringWithFormat:@"%zd-%zd",item.year,item.month] forState:UIControlStateNormal] ;
}

- (void)p_handleSelectedItem:(DDCalendarDayItem *)dayItem
{
    for (DDCalendarMonthItem  * monthItem in self.monthItems) {
        for (DDCalendarDayItem * dayItem_ in monthItem.items) {
//            dayItem.selected = dayItem_==dayItem ;
            if (dayItem_==dayItem) {
                dayItem_.selected = YES ;
            }else
            {
                dayItem_.selected = NO ;
            }
        }
    }
}

@end
