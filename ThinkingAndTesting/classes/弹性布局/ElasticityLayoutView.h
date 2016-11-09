//
//  ElasticityLayoutView.h
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElasticityEntity : NSObject

@property (nonatomic, copy) NSString * title ;
@property (nonatomic, copy) NSString * imageName ;
@property (nonatomic, copy) NSString * selector ;

- (instancetype)initWithDic:(NSDictionary *) dic ;

@end

@interface ElasticityLayoutView : UIView

@property (nonatomic, strong) NSArray <ElasticityEntity * > * datas ;

@property (nonatomic, copy) void (^whenClick)(ElasticityEntity *) ;
@end
