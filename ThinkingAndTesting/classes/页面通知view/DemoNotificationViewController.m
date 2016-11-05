//
//  DemoNotificationViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/11/4.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoNotificationViewController.h"
#import "NotificationView.h"
#import "UINavigationBar+CustomStyle.h"

@interface DemoNotificationViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NotificationView * nv ;
@end

@implementation DemoNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈" ;
    self.nv = [NotificationView notificationView ] ;
    self.nv.contentBackgroundColor = [UIColor redColor] ;
    [self.view addSubview:_nv] ;
    self.nv.dd_top = 64 ;
    
    self.nv.content = @"测试一下能不能滚动呀，能不能流畅呀，哈哈。不知道呀!!!!滚起来，嗨起来！！！" ;

    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"YouTube" style:UIBarButtonItemStylePlain target:nil action:nil] ;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor] backIndicatorImage:nil titleColor:[UIColor blackColor] rightItemColor: [UIColor blueColor]] ;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.nv.content = @"能不能换文本勒！！！能不能！！！" ;
    
    [self.navigationController.navigationBar restoreNavigationBar] ;
    return ;
    
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    picker.delegate = self ;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh ;
//    picker.allowsEditing = YES ;
    [self presentViewController:picker animated:YES completion:nil] ;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                   NSForegroundColorAttributeName : [UIColor redColor]
                                                                   } forState:UIControlStateNormal] ;
    
    
//    viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor yellowColor] ;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
    DDLog(@"%@",info) ;
    UIImage * image = info[UIImagePickerControllerOriginalImage] ;
    self.view.layer.contents = (id)image.CGImage ;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
    DDLog(@"用户主动取消") ;
}
@end
