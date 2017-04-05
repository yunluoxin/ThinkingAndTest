//
//  DDAuthCell.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAuthCellConfig.h"

@class DDAuthCell ;

@protocol DDAuthCellDelegate <NSObject>

@optional
- (void)cell:(DDAuthCell *)cell didTapAtIndex:(NSInteger)index extendEventFlag:(NSString *)flag ;

@end

@interface DDAuthCell : UITableViewCell
/**
 *
 */
@property (nonatomic, strong)DDAuthCellConfig * config ;

@end
