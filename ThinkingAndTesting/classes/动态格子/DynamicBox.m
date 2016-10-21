//
//  DynamicBox.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DynamicBox.h"
#import "BoxEntity.h"
#import "BoxCell.h"



@interface DynamicBox ()

@property (nonatomic, strong) NSMutableArray * reusedViews ;

@end

@implementation DynamicBox

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _countsPerRow = 3 ;
        self.backgroundColor = [UIColor greenColor] ;
    }
    return self ;
}

- (void)setEntities:(NSArray<BoxEntity *> *)entities
{
    _entities = entities ;
    
    [self prepareForUse] ;
    
    if (!entities || entities.count == 0) {
        return ;
    }
    
    if (entities.count > self.reusedViews.count) {
        NSUInteger needToCreate = entities.count - self.reusedViews.count ;

        for (int i = 0 ; i < needToCreate; i ++ ) {
            BoxCell * cell = [BoxCell new] ;
            cell.hidden = YES ;
            [self addSubview:cell] ;
            [self.reusedViews addObject:cell] ;
        }
    }
    
    CGFloat spacing = 1  ;
    CGFloat w = ( self.dd_width - spacing * (self.countsPerRow - 1) ) / self.countsPerRow ;
    CGFloat h = 100 ;
    for (int i = 0 ; i < self.entities.count ; i ++ ) {
        BoxCell * cell = self.reusedViews[i] ;
        NSUInteger row = i / self.countsPerRow ;
        NSUInteger col = i % self.countsPerRow ;
        
        CGFloat x = ( w + spacing ) * col ;
        CGFloat y = ( h + spacing ) * row ;
        
        cell.frame = CGRectMake(x, y, w, h) ;
        cell.entity = self.entities[i] ;
        cell.hidden = NO ;
    }
    
    UIView * lastView = self.reusedViews[self.entities.count - 1];
    self.dd_height = lastView.dd_bottom ;
    
}

- (void)prepareForUse
{
    for (int i = 0 ; i < self.reusedViews.count;  i ++) {
        UIView *view = self.reusedViews[i ];
        view.hidden = YES ;
    }
}

- (NSMutableArray *)reusedViews
{
    if (!_reusedViews) {
        _reusedViews = @[].mutableCopy ;
    }
    return _reusedViews ;
}
@end
