//
//  ImagePickerDelegate.h
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completeHandler)(UIImage * originalImage, UIImage * editedImage, NSError * error) ;

@interface ImagePickerDelegate : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/**
 请在调用API之前先设置，默认是不可编辑
 @param allowEdit 是否可以编辑
 */
+ (void)allowedEdit:(BOOL)allowEdit ;

+ (void)showToastUsingDefaultStyleWithCompleteHandler:(completeHandler)block ;
@end
