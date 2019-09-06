//
//  FileBrowseUploadingView.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/7/29.
//  Copyright © 2019 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileBrowseUploadingView : UIView

/// IP地址
@property (nonatomic, copy) NSString *address;

/// 退出上传模式的回调
@property (nonatomic, copy) void (^exitUploadingMode)(void);

@end

NS_ASSUME_NONNULL_END
