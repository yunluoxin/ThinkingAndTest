//
//  ElasticityCell.h
//  ThinkingAndTesting
//
//  Created by ZhangXiaodong on 16/11/9.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElasticityLayoutView.h"
@interface ElasticityCell : UITableViewCell

@property (nonatomic, strong) NSArray <ElasticityEntity * > * datas ;

+ (instancetype)cellWithTableView:(UITableView * )tableView ;

@end
