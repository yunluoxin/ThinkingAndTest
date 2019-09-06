//
//  FileBrowseImageViewController.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/9/6.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDFileModel;

NS_ASSUME_NONNULL_BEGIN

@interface FileBrowseImageViewController : UIViewController
@property (nonatomic, strong) DDFileModel *file;
@end

NS_ASSUME_NONNULL_END
