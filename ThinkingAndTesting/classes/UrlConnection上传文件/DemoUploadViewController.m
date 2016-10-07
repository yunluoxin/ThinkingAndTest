//
//  DemoUploadViewController.m
//  ThinkingAndTesting
//
//  Created by dadong on 16/9/22.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "DemoUploadViewController.h"
//#import "DDUtils.h"
#import "DDUtils+UrlConnectionUpload.h"
@interface DemoUploadViewController ()

@end

@implementation DemoUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = @"http://192.168.0.237:8182/mobile/dc/upload" ;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"png"];
    DDLog(@"%@",path) ;
//    NSData *data = [NSData dataWithContentsOfFile:path] ;
    UIImage *image = [UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] ;
    NSData *data = UIImageJPEGRepresentation( image, 1 ) ;
    [DDUtils uploadUrl:url parameters:nil multipartDatas:@{
                                                          @"file":data
                                                          } success:^(NSData *data) {
                                                              DDLog(@"上传成功") ;
                                                              DDLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]) ;
                                                          } error:^(NSData * _Nullable data, NSError * _Nullable connectionError) {
                                                              DDLog(@"上传失败%@",connectionError) ;
                                                              DDLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]) ;
                                                          }] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
