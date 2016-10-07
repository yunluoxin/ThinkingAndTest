//
//  DemoImagePickerController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/29.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoImagePickerController.h"

@interface DemoImagePickerController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView *_imageV ;
}
@property (nonatomic, strong) UIImagePickerController *picker ;
@end

@implementation DemoImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES ;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.bounds] ;
    [self.view addSubview:imageV] ;
    _imageV = imageV ;
    imageV.contentMode = UIViewContentModeScaleAspectFit ;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    btn.frame = CGRectMake(100, 100, 100, 30) ;
    [btn setTitle:@"打开相册" forState:UIControlStateNormal] ;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal] ;
    [self.view addSubview:btn] ;
    [btn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside] ;
    


}

- (void)open
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择一个类型" message:@"图片浏览器" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoAlbum] ;
    }];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"用摄像头拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera] ;
    }];
    
    [alert addAction:cancel] ;
    [alert addAction:album] ;
    [alert addAction:camera] ;
    
    [self presentViewController:alert animated:YES completion:nil] ;
}
- (void)openPhotoAlbum
{
    self.picker = [UIImagePickerController new] ;
//    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum ;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ; //和photAlbum的区别是，album只有相册的时刻，没有其他的可以选择的，而photoLibrary则是所有的！整个库
    _picker.delegate = self ;
    //    _picker.allowsEditing = YES ;
    [self presentViewController:self.picker animated:YES completion:nil] ;
}

- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前设备无法使用相机" preferredStyle:UIAlertControllerStyleAlert]  ;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:action] ;
        [self presentViewController:alert animated:YES completion:nil] ;
        return ;
    }
    self.picker = [UIImagePickerController new] ;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera ;  //照相机返回的还带有一个metaData元数据，里面带有各种曝光，时间等信息
    _picker.delegate = self ;
//        _picker.allowsEditing = YES ;
    [self presentViewController:self.picker animated:YES completion:nil] ;
}

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
    _imageV.image = selectedImage ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
    
    //如果是相机模式，把照相到的图片保存到相册
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil) ;
    }

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"%s",__func__) ;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews] ;
    _imageV.frame = self.view.bounds ;
}
@end
