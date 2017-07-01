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

const CGFloat DDCalendarViewHeight = 44.0+35+35*6 ; // 其中44是年份显示的，35是星期标志， 35*6是几号的


@interface DDCalendarView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UIButton *currentYearMonthLabel;

/// 星期标志
@property (weak, nonatomic) IBOutlet UIView *weekFlagsView;

/// 当前所在的月份
@property (strong, nonatomic)DDCalendarMonthItem * currentMonthItem ;

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
    
    self.currentYearMonthLabel.layer.cornerRadius = self.currentYearMonthLabel.frame.size.height / 2 ;
    self.currentYearMonthLabel.layer.masksToBounds = YES ;

    NSArray * weeks = @[@"日",@"一",@"二", @"三", @"四",@"五", @"六"] ;
    CGFloat w = [UIScreen mainScreen].bounds.size.width / weeks.count ;
    CGFloat h = self.weekFlagsView.frame.size.height ;
    for (NSUInteger i = 0; i < weeks.count; i ++) {
        CGFloat x = w * i ;
        CGFloat y = 0 ;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)] ;
        label.text = weeks[i] ;
        label.textColor = [UIColor grayColor] ;
        label.textAlignment = NSTextAlignmentCenter ;
        [self.weekFlagsView addSubview:label] ;
    }
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, h - 1/IOS_SCALE, [UIScreen mainScreen].bounds.size.width, 1/IOS_SCALE)] ;
    line.backgroundColor = [UIColor lightGrayColor] ;
    [self.weekFlagsView addSubview:line] ;
    
    // setup collectionView
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(DDCalendarViewMonthCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(DDCalendarViewMonthCell.class)] ;
    

}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    // 布局月日历视图
    CGFloat width = [UIScreen mainScreen].bounds.size.width ;
    CGFloat height = self.dd_height - self.weekFlagsView.dd_bottom ;
    self.flowLayout.itemSize = CGSizeMake(width, height) ;
    self.flowLayout.minimumLineSpacing = 0 ;
    self.flowLayout.minimumInteritemSpacing = 0 ;
}

#pragma mark - setter and setter 

- (void)setMonthItems:(NSArray *)monthItems
{
    _monthItems = monthItems ;
    
    [self.collectionView reloadData] ;
}

#pragma mark - Actions 

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

    [self.currentYearMonthLabel setTitle:[NSString stringWithFormat:@"%zd-%02zd",item.year,item.month] forState:UIControlStateNormal] ;
    
    self.currentMonthItem = item ;
    
    // 回调
    if (_delegate && [_delegate respondsToSelector:@selector(calendarView:didScrollToItem:)])
    {
        [_delegate calendarView:self didScrollToItem:item] ;
    }
}

// 处理选择了某一天
- (void)p_handleSelectedItem:(DDCalendarDayItem *)dayItem
{
    for (DDCalendarMonthItem  * monthItem in self.monthItems) {
        for (DDCalendarDayItem * dayItem_ in monthItem.items) {
            dayItem_.selected = dayItem_==dayItem ;
//            dayItem_.hasRecord = dayItem==dayItem_ ;
        }
    }
    
    // 回调
    if (_delegate && [_delegate respondsToSelector:@selector(calendarView:didSelectAtItem:)])
    {
        [_delegate calendarView:self didSelectAtItem:dayItem] ;
    }
}

@end
