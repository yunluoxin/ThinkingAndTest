//
//  InfoShowScrollView.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/12/10.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "InfoShowScrollView.h"
#import "InfoShowCell.h"

@interface InfoShowScrollView ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _lastOffsetY ;
}

@property (nonatomic, strong) NSMutableArray * cells ;

@property (nonatomic, strong) NSTimer * timers ;

@end

@implementation InfoShowScrollView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [UIColor whiteColor] ;
        self.visibleCellCountEveryTime = 2 ;
        self.delegate = self ;
        self.dataSource = self ;
        self.separatorStyle = UITableViewCellSeparatorStyleNone ;
        self.showsVerticalScrollIndicator = NO ;
        self.showsHorizontalScrollIndicator = NO ;
        self.pagingEnabled = YES ;
    }
    return self ;
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSections
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infos.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = self.dd_height ;
    
    if (self.infos.count > 1) {
        h = self.dd_height / self.visibleCellCountEveryTime;
    }
    
    return h ;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoShowCell * cell = [InfoShowCell cellWithTableView:tableView ] ;
    
    NSAttributedString * content = self.infos[indexPath.row] ;
    cell.content = content ;
    
    return cell ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.whenClickAtRow) {
        self.whenClickAtRow(indexPath.row) ;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer] ;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lastOffsetY = scrollView.contentOffset.y ;
    
    [self timers] ;
}


#pragma mark - setter and getter

- (void)setInfos:(NSMutableArray<NSAttributedString *> *)infos
{
    _infos = infos ;
    
    [self resetState] ;
}


- (void)setVisibleCellCountEveryTime:(NSInteger)visibleCellCountEveryTime
{
    _visibleCellCountEveryTime = visibleCellCountEveryTime ;
    
    [self resetState] ;
}


#pragma mark - private methods

- (NSTimer *)timers
{
    if (!_timers) {
        _timers = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scroll) userInfo:nil repeats:YES] ;
    }
    return _timers ;
}

- (void)stopTimer
{
    if (_timers) {
        [_timers invalidate] ;
        _timers = nil ;
    }
}

- (void)scroll
{
    _lastOffsetY = _lastOffsetY + self.dd_height ;
    
    if (_lastOffsetY >= self.contentSize.height) {
        _lastOffsetY = 0 ;
    }
    
    [self setContentOffset:CGPointMake(0, _lastOffsetY) animated:YES] ;
}

- (void)resetState
{
    [self stopTimer] ;
    
    [self reloadData] ;
    
    _lastOffsetY = 0 ;
    
    if (self.infos && self.infos.count > self.visibleCellCountEveryTime) {
        [self timers] ;
    }
}

- (void)didMoveToSuperview
{
    if (self.superview) {
        [self resetState] ;
    }else{
        [self stopTimer] ;
    }
}
@end
