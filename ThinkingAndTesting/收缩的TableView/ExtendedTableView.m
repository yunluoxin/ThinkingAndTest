//
//  ExtendedTableView.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/7/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "ExtendedTableView.h"

@interface ExtendedTableView ()

@property (nonatomic, strong) NSIndexPath *currentIndexPath ;

@property (nonatomic, weak) id extended_delegate ;

@end

@implementation ExtendedTableView

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.extended_delegate = delegate ;
    [super setDelegate:delegate];
}

- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated goToTop:(BOOL)goToTop
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.currentIndexPath) {
        NSIndexPath *unselectedIndex = [NSIndexPath indexPathForRow:self.currentIndexPath.row inSection:self.currentIndexPath.section];
        [array addObject:unselectedIndex];
        
        if ([self isEqualToSelectedIndexPath:indexPath]) {
            
        }else{
            [array addObject:indexPath];
        }
        
    }else{
        [array addObject:indexPath];
    }
    
    self.currentIndexPath = indexPath ;
    
    if (animated) {
        [self reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (goToTop) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
    }
}


- (void)shrinkCellWithAnimated:(BOOL)animated
{
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.currentIndexPath) {
        [array addObject:self.currentIndexPath];
        
//        self.currentIndexPath = nil ;
        
        [self reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (BOOL)isEqualToSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    if (!self.currentIndexPath) {
        return NO ;
    }
    if (selectedIndexPath.row == self.currentIndexPath.row && selectedIndexPath.section == self.currentIndexPath.section) {
        return YES ;
    }
    return NO ;
}

@end
