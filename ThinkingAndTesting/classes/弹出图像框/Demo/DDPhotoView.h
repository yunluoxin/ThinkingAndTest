//
//  DDPhotoView.h
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/2/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPhotoView : UIScrollView
@property (nonatomic, strong)UIImage *image ;

+ (instancetype)showImage:(UIImage *)image ;

@end
