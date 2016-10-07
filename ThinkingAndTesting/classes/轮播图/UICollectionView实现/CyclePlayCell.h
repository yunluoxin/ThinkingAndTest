//
//  CyclePlayCell.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/6/7.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleEntity : NSObject

@property (nonatomic, strong) NSString * id ;
@property (nonatomic, strong) NSString * imageUrl ;
@property (nonatomic, strong) NSString * linkUrl ;
@property (nonatomic, strong) NSDictionary * extra ;

@end


@interface CyclePlayCell : UICollectionViewCell

@property (nonatomic, strong) CycleEntity * entity ;

@end

FOUNDATION_EXPORT NSString * const CyclePlayCellIdentifier ;