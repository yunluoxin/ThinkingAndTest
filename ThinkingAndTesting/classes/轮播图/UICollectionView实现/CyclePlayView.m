//
//  CyclePlayView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "CyclePlayView.h"
#import "CyclePlayCell.h"

@interface CyclePlayView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger _times ;  //假设有n个图片计入循环
}

@property (nonatomic, weak) UICollectionView *collectionView ;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout ;
@property (nonatomic, strong) NSTimer *timer ;

@property (nonatomic, assign) NSInteger currentIndex ;
@end

@implementation CyclePlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _times = INT_MAX ;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal ;    //水平滚动
        layout.minimumInteritemSpacing = 0.0f ;
        layout.minimumLineSpacing = 0.0f ;
        layout.sectionInset = UIEdgeInsetsZero ;
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        self.layout = layout ;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView = collectionView ;
        [self addSubview:self.collectionView];
        self.collectionView.pagingEnabled = YES ;
        self.collectionView.showsHorizontalScrollIndicator = NO ;
        self.collectionView.showsVerticalScrollIndicator = NO ;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self ;
        self.collectionView.delegate = self ;
        [self.collectionView registerClass:[CyclePlayCell class] forCellWithReuseIdentifier:CyclePlayCellIdentifier];
    }
    return self ;
}


#pragma mark - UICollectionView的DataSource方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrayList && self.arrayList.count > 0) { //防止刚开始网络还没获取到，导致数量为0，就开始循环加载导致出错
        return _times ;
    }
    return 0 ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CyclePlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CyclePlayCellIdentifier forIndexPath:indexPath];
    cell.entity = self.arrayList[indexPath.row % self.arrayList.count];
    return cell ;
}


#pragma mark - UICollectionView的代理方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择
    [collectionView deselectItemAtIndexPath:indexPath animated:NO] ;
    
//    DDLog(@"点击了第%ld行",indexPath.row % self.arrayList.count);
    
    if (_delegate && [_delegate respondsToSelector:@selector(cyclePlayView:didSelectedItemAtIndex:)]) {
        [_delegate cyclePlayView:self didSelectedItemAtIndex:(indexPath.row % self.arrayList.count )] ;
    }
}

#pragma mark - UIScrollView的代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endCycle];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x ;
    int index = contentOffsetX / scrollView.dd_width + 0.5 ;
    self.currentIndex = index ;
    
    [self beginCycle];
}


#pragma mark - setter And getter方法

- (void)setArrayList:(NSArray<CycleEntity *> *)arrayList
{
    _arrayList = arrayList ;
    
    [self.collectionView reloadData];
}


- (void)beginCycle
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(cyclePlay) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)endCycle
{
    [_timer invalidate];
    _timer = nil ;
}

- (void)cyclePlay
{
    self.currentIndex ++ ;

    [self.collectionView setContentOffset:CGPointMake(self.currentIndex * self.collectionView.dd_width, 0) animated:YES];
}




- (void)didMoveToSuperview
{
    if (self.superview) {
        [self beginCycle];
    }
}

- (void)removeFromSuperview
{
    [self endCycle];
}

- (void)dealloc
{
    [self endCycle];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds ;
    self.layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}
@end
