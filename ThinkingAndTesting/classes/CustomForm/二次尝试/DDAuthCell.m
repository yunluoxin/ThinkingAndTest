//
//  DDAuthCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "DDAuthCell.h"
#import "MJExtension.h"
#import "AuthImageCell.h"

#import "DDPhotoView.h"

@interface DDAuthCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id<DDAuthCellDelegate> delegate ;
@end

@implementation DDAuthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone ;
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    [self.collectionView registerNib:[UINib nibWithNibName:@"AuthImageCell" bundle:nil] forCellWithReuseIdentifier:@"AuthImageCell"] ;
}

- (void)didMoveToSuperview
{
    if (self.superview) {
        DDLog(@"%s",__FUNCTION__) ;
        UITableView * tableView = (UITableView *)self.superview.superview ;
        self.delegate = (id)tableView.delegate ;
    }
}

- (void)setConfig:(DDAuthCellConfig *)config
{
    _config = config ;
    
    self.titleLabel.text = config.title ;
    
    DDLog(@"%s",__FUNCTION__) ;
    
    [self.collectionView reloadData] ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDLog(@"%s",__FUNCTION__) ;
    CGFloat w = (DD_SCREEN_WIDTH - 20 - 8 * 4) / 4 ;
    return CGSizeMake(w, w) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8 ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8 ;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray<AuthCellImageItemConfig *> *array = self.config.stagingValue ;
    
    return array.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDLog(@"%s",__FUNCTION__) ;
    __weak typeof(self) wself = self ;
    AuthImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AuthImageCell" forIndexPath:indexPath] ;
    
    NSArray<AuthCellImageItemConfig *> *array = self.config.stagingValue ;
    
    AuthCellImageItemConfig * config = array[indexPath.row] ;
    
    cell.config = config ;
    
    cell.whenTapDeleteImage = ^(AuthImageCell * cell){
        [collectionView reloadData] ;
    } ;
    
    cell.whenTapFullScreen = ^(AuthImageCell * cell){
        if (config.isTemlate) {
            [DDPhotoView showImage:config.templatedImage] ;
        }else{
            [DDPhotoView showImage:config.selectedImage] ;
        }
    } ;
    
    cell.whenTapAddImage = ^(AuthImageCell * cell){
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(cell:didTapAtIndex:extendEventFlag:)]) {
            [wself.delegate cell:self didTapAtIndex:[array indexOfObject:config] extendEventFlag:nil] ;
        }
    } ;
    
    return cell ;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    DDLog(@"%s",__FUNCTION__) ;
    

    // 必须异步，让collectionView大小先变化， 此操作在下一个runloop操作
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 让collectionView不滚动
        self.collectionView.dd_height = self.collectionView.contentSize.height ;
        
        // 你想要设置的高度
        CGFloat targetHeight = self.collectionView.dd_bottom + 8 ;
        
        // 为了防止无止境的滚动，只有在两次高度变化的时候才刷新
        if (self.config.cellHeight != targetHeight) {
            self.config.cellHeight = targetHeight ;
            UITableView * tableView = (UITableView *)self.superview.superview ;
            [tableView reloadData] ;
        }
        
    }) ;
}

@end
