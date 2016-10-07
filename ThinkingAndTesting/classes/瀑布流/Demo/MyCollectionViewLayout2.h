//
//  MyCollectionViewLayout2.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewLayout2 : UICollectionViewLayout

@property (nonatomic, assign)CGFloat spacing ;
@property (nonatomic, assign)CGFloat interSpacing ;
@property (nonatomic, assign)NSUInteger colNumber ; //列数
@property (nonatomic, assign)UIEdgeInsets sectionEdgeInset ;   //内边距
@property (nonatomic, copy)CGFloat (^heightForCell)(NSIndexPath * , CGFloat);

@end
