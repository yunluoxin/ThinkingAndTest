//
//  CircleIndicatorsView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/4/12.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleIndicatorsView : UIView

@property (nonatomic, assign) NSInteger totalCount ;

@property (nonatomic, assign) NSInteger currentTintCount ;

@property (nonatomic, strong) UIColor *normalColor ;

@property (nonatomic, strong) UIColor *tintColor ;

@end
