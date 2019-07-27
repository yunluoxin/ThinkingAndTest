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
@property (nonatomic, copy) NSString *dir;          /**< 当前文件所在的目录 */
@property (nonatomic, copy) NSString *fileName;     /**< 当前文件的文件名 */
@property (nonatomic, assign) BOOL isDir;           /**< 当前文件是否是目录 */
/**
 当前文件的路径
 */
- (NSString *)filePath;
@end

@interface FileBrowseViewController : UIViewController
/**
 当前页面的根文件
 如果文件是文件，就显示文本。如果文件是目录，就显示当前目录下所有文件
 */
@property (nonatomic, strong) DDFileModel *file;
@end

NS_ASSUME_NONNULL_END
