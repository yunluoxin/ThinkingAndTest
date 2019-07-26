//
//  FileBrowseViewController.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/26.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDFileModel : NSObject
@property (nonatomic, copy) NSString *dir;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) BOOL isDir;
- (NSString *)filePath;
@end

@interface FileBrowseViewController : UIViewController
@property (nonatomic, strong) DDFileModel *file;
@end

NS_ASSUME_NONNULL_END
