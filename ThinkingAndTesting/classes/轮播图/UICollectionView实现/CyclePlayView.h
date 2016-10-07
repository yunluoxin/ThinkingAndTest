//
//  CyclePlayView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CyclePlayCell.h"

@class CyclePlayView ;

@protocol CyclePlayViewDelegate <NSObject>

- (void)cyclePlayView:(CyclePlayView *)cyclePlayView didSelectedItemAtIndex:(NSInteger)index ;

@end


@interface CyclePlayView : UIView

@property (nonatomic, strong) NSArray<CycleEntity *>  * arrayList ;

@property (nonatomic, weak) id<CyclePlayViewDelegate>   delegate ;

@end
