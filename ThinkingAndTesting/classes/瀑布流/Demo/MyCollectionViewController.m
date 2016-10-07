//
//  MyCollectionViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionViewLayout.h"
#import "MyCollectionViewLayout2.h"
#import "MyCollectionViewCell.h"
#import "People.h"

@interface MyCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *data ;

@property (nonatomic, strong) UICollectionView *collectionView ;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    
    MyCollectionViewLayout *layout = [MyCollectionViewLayout new];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
//    layout.heightForCell = ^(NSIndexPath *indexPath , CGFloat width){
//        People *p = self.data[indexPath.row] ;
//        
//        return [p.height doubleValue];
//    };
//    
    
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"id"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)data
{
    if (!_data) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0 ; i < 100000; i ++) {
            NSUInteger r = arc4random() % 100 ;    //[0-100)生成随机数
            People *p = [People new];
            p.age = @(r/2) ;
            p.name = [NSString stringWithFormat:@"代号%ld",r];
            p.height = @(r) ;
            [arrayM addObject:p];
        }
        _data = [arrayM copy];
    }
    return _data ;
}


#pragma mark - UICollectionViewDataSource
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
    People *p = self.data[indexPath.row];
    MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    cell.label.text = p.name ;
    return cell ;
}

@end
