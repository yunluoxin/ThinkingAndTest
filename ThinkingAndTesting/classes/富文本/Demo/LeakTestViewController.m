//
//  LeakTestViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "LeakTestViewController.h"
#import "LeakTestCell.h"

@interface LeakTestViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView ;

@property (nonatomic, strong) NSMutableArray * data ;
@end

@implementation LeakTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"富文本是否会泄露" ;
    
    [self.view addSubview:self.collectionView] ;
    
}

#pragma mark - UICollectionViewDataSource Methods 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LeakTestCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LeakTestCell" forIndexPath:indexPath] ;
    cell.content = self.data[indexPath.row] ;
    return cell ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - getter and setter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new] ;
        layout.itemSize = CGSizeMake(DD_SCREEN_WIDTH / 2 - 8, 300) ;
        layout.minimumLineSpacing = 8 ;
        layout.minimumInteritemSpacing = 8 ;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout] ;
        _collectionView.dataSource = self ;
        _collectionView.delegate = self ;
        _collectionView.backgroundColor = [UIColor yellowColor] ;
        
        [_collectionView registerClass:[LeakTestCell class] forCellWithReuseIdentifier:@"LeakTestCell"] ;
    }
    return _collectionView ;
}

- (NSMutableArray *)data
{
    if (!_data) {
        _data = @[].mutableCopy ;
        for (int i = 0 ; i < 100 ; i ++) {
            int s = arc4random_uniform(3) ;
            int s2 = arc4random_uniform(3) ;
            NSString * str = [NSString stringWithFormat:@"%d--[img_%d]--[img_%d]",i, s, s2] ;
            [_data addObject:str] ;
            str = nil ;
        }
    }
    return _data ;
}


@end
