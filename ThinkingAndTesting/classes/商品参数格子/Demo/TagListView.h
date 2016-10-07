//
//  TagListView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/19.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagListView : UIView

@property (nonatomic, strong) NSArray *tagContentArray ;
@property (nonatomic, strong) NSArray *keyArray ;   //如果标签 要绑定一些标识，就顺序传进来这个，和上面的相对应

@end
