//
//  DynamicBox.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/10/20.
//  Copyright © 2016年 dadong. All rights reserved.
//

@class BoxEntity ;

@interface DynamicBox : UIView

@property (nonatomic, assign) NSInteger countsPerRow ;

@property (nonatomic, strong) NSArray<BoxEntity *> * entities ;

@end
