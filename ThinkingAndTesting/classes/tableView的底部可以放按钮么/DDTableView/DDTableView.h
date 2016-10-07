//
//  DDTableView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/3.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTableView : UITableView
@property (nonatomic, copy)NSString *tips ;

@property (nonatomic, copy)void (^whenRefreshBtnClicked)(void);
@end
