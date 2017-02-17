//
//  UITableView+DDAdd.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/2/7.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "UITableView+DDAdd.h"

@implementation UITableView (DDAdd)

- (void)clearSelectedRowsAnimated:(BOOL)animated
{
    NSArray * indexs = [self indexPathsForSelectedRows] ;
    for (NSIndexPath * index in indexs)
    {
        [self deselectRowAtIndexPath:index animated:animated] ;
    }
}

- (void)selectAllRowsAnimated:(BOOL)animated
{
    NSUInteger sections = self.numberOfSections ;
    for (NSUInteger i = 0 ; i < sections ; i ++)
    {
        NSInteger rows = [self numberOfRowsInSection:i] ;
        for (NSUInteger j = 0 ;j < rows ; j ++)
        {
            [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:animated scrollPosition:UITableViewScrollPositionNone] ;
        }
    }
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation] ;
}

- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:row inSection:section] ;
    [self reloadRowsAtIndexPaths:@[index] withRowAnimation:animation] ;
}

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation] ;
}

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation] ;
}

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation] ;
}

- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:row inSection:section] ;
    [self insertRowsAtIndexPaths:@[index] withRowAnimation:animation] ;
}

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    [self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation] ;
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation] ;
}

- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:row inSection:section] ;
    [self deleteRowsAtIndexPaths:@[index] withRowAnimation:animation] ;
}

- (void)deselectRow:(NSUInteger)row inSection:(NSUInteger)section animated:(BOOL)animated
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:row inSection:section] ;
    [self deselectRowAtIndexPath:index animated:animated] ;
}
@end
