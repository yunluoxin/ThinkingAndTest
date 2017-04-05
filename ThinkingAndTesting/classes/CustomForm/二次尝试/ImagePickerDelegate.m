//
//  ImagePickerDelegate.m
//  ThinkingAndTesting
//
//  Created by dadong on 17/4/1.
//  Copyright © 2017年 dadong. All rights reserved.
//

#import "ImagePickerDelegate.h"

@interface ImagePickerDelegate ()
{
    BOOL _allowEdit ;
}
@property (nonatomic, strong)UIImagePickerController * picker ;


@property (nonatomic, copy) completeHandler block ;



@end

@implementation ImagePickerDelegate

+ (instancetype)sharedDelegate
{
    static id delegate ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[self alloc] init] ;
    });
    return delegate ;
}

#pragma mark - public API

+ (void)showToastUsingDefaultStyleWithCompleteHandler:(completeHandler)block
{
    NSAssert(block, @"completeHandler不能为空") ;
    
    [[self sharedDelegate] setBlock:block] ;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择一个类型" message:@"图片浏览器" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[self sharedDelegate] openPhotoAlbum] ;
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"用摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[self sharedDelegate] openCamera] ;
    }];
    
    [alert addAction:cancel] ;
    [alert addAction:album] ;
    [alert addAction:camera] ;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil] ;
}


+ (void)openPhotoAlbumWithCompleteHandler:(completeHandler)block
{
    NSAssert(block, @"completeHandler不能为空") ;
    
    [[self sharedDelegate] setBlock:block] ;
    
    [[self sharedDelegate] openPhotoAlbum] ;
}

+ (void)openCameraWithCompleteHandler:(completeHandler)block
{
    NSAssert(block, @"completeHandler不能为空") ;
    
    [[self sharedDelegate] setBlock:block] ;
    
    [[self sharedDelegate] openCamera] ;
}

+ (void)allowedEdit:(BOOL)allowEdit
{
    ImagePickerDelegate * delegate = [self sharedDelegate] ;
    delegate->_allowEdit = allowEdit ;
}

#pragma mark - private 

- (void)openPhotoAlbum
{
    //    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum ;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ; //和photAlbum的区别是，album只有相册的时刻，没有其他的可以选择的，而photoLibrary则是所有的！整个库
    
    self.picker.allowsEditing = _allowEdit ;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.picker animated:YES completion:nil] ;
}

- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前设备无法使用相机" preferredStyle:UIAlertControllerStyleAlert]  ;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action] ;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil] ;
        return ;
    }

    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera ;  //照相机返回的还带有一个metaData元数据，里面带有各种曝光，时间等信息

    self.picker.allowsEditing = _allowEdit ;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.picker animated:YES completion:nil] ;
}


#pragma mark - UIImagePickerController delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info) ;
    
    UIImage *selectedImage = nil ;
    if (picker.allowsEditing) {
        //获取到的是编辑后的图
        selectedImage = info[UIImagePickerControllerEditedImage] ;
    }else{
        //获取到的是原图
        selectedImage = info[UIImagePickerControllerOriginalImage] ;
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil] ;
    
    //如果是相机模式，把照相到的图片保存到相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil) ;
    }else{
        if (self.block) {
            self.block(info[UIImagePickerControllerOriginalImage], info[UIImagePickerControllerEditedImage], nil) ;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //改变弹框状态栏的 "取消的" 颜色
    [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                               NSForegroundColorAttributeName : [UIColor redColor]
                                                                               } forState:UIControlStateNormal] ;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    DDLog(@"%s",__func__) ;
    
    if (self.block) {
        self.block(image, nil, error) ;
    }
}



#pragma mark - getter and setter 
- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [UIImagePickerController new] ;
        _picker.delegate = self ;
    }
    return _picker ;
}


- (void)dealloc
{
    self.block = nil ;
}

@end
