//
//  FileBrowseImageViewController.m
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2019/9/6.
//  Copyright © 2019 dadong. All rights reserved.
//
//  TODO: 加载gif

#import "FileBrowseImageViewController.h"
#import "FileBrowseViewController.h"

@interface FileBrowseImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *photoView;
@end

@implementation FileBrowseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = self.file.fileName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupRightItemShareIcon];
    [self setupDouleScaleGesture];
    
    [self.view addSubview:self.photoView];
    [self.photoView addSubview:self.imageView];
}

/// 双击缩放手势
- (void)setupDouleScaleGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    gesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:gesture];
}

- (void)setupRightItemShareIcon {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareSingleFile:)];
}


#pragma mark - Actions

/**
 分享当前文件
 */
- (void)actionShareSingleFile:(id)sender {
    if (self.file.isDir) return;
    
    NSURL *fileURL = [NSURL fileURLWithPath:self.file.filePath];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

/// 双击屏幕
- (void)didDoubleTap:(id)sender {
    if (self.photoView.zoomScale > 1) {
        [self.photoView setZoomScale:1.0 animated:YES];
    } else {
        [self.photoView setZoomScale:self.photoView.maximumZoomScale animated:YES];
    }
}


/// 单击图片 切换全屏视图/正常视图
- (void)didTapImageView:(id)sender {
    if (self.navigationController.navigationBarHidden) {
        // 全屏 -> 正常
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        // 正常 -> 全屏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.view.backgroundColor = [UIColor blackColor];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - lazy load

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit; // 适应模式
        _imageView.image = [[UIImage alloc] initWithContentsOfFile:self.file.filePath];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
        [tap requireGestureRecognizerToFail:self.view.gestureRecognizers.firstObject];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UIScrollView *)photoView {
    if (!_photoView) {
        _photoView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _photoView.minimumZoomScale = 1.0;
        _photoView.maximumZoomScale = 3.0;
        _photoView.delegate = self;
        _photoView.contentSize = self.view.bounds.size;
        if (@available(ios 11.0, *)) {
            _photoView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _photoView;
}
@end
