//
//  DDFormCell.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/15.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DDFormCell.h"
#import "NormalView.h"

@interface DDFormCell ()

@property (nonatomic, strong) NSMutableArray * mainViews ;

@end

@implementation DDFormCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"DDFormCell" ;
    DDFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    return cell ;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews] ;
    }
    return self ;
}

#pragma mark - create subviews here

- (void)initSubViews
{
    NormalView *nView = [NormalView new] ;
    nView.hidden = YES ;
    nView.tagString = @"normal" ;
    [self.contentView addSubview:nView] ;
    [self.mainViews addObject:nView] ;
}



#pragma mark - getter and setter

- (void)setItem:(FormItem *)item
{
    _item = item ;
    
    for (UIView<DDFormProtocol> *view in self.mainViews) {
        if ([view.tagString isEqualToString:item.cellType]) {
            view.item = item ;
            view.hidden = NO ;
        }else{
            view.hidden = YES ;
        }
    }
}

- (void)setWhenOpearte:(void (^)(UIView *, NSString *, FormItem *))whenOpearte
{
    for (UIView<DDFormProtocol> *view in self.mainViews) {
        view.whenOpearte = whenOpearte ;
    }
    
}

- (NSMutableArray *)mainViews
{
    if (!_mainViews) {
        _mainViews = [NSMutableArray array] ;
    }
    return _mainViews ;
}

#pragma mark - override -layoutSubviews to set frame

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    for (UIView *view in self.mainViews) {
        view.frame = self.contentView.bounds ;
    }
}
@end
