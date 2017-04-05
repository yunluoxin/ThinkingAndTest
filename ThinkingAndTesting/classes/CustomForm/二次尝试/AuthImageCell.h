//
//  AuthImageCell.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAuthCellConfig.h"
@interface AuthImageCell : UICollectionViewCell

/**
 *  <#note#>
 */
@property (nonatomic, strong)AuthCellImageItemConfig * config ;


@property (nonatomic, copy) void (^whenTapAddImage)(AuthImageCell *cell) ;

@property (nonatomic, copy) void (^whenTapFullScreen)(AuthImageCell *cell) ;

@property (nonatomic, copy) void (^whenTapDeleteImage)(AuthImageCell *cell) ;
@end
