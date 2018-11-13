//
//  OperationQueueViewController.h
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2018/11/12.
//  Copyright © 2018 dadong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OperationQueueViewController : UIViewController

@end

@interface CustomOperation : NSOperation
@end

@interface ConcurrentOperation : NSOperation
@end

NS_ASSUME_NONNULL_END
