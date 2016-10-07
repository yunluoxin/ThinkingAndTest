//
//  QRScanViewController.m
//  ThinkingAndTesting
//
//  Created by 张小冬 on 16/5/6.
//  Copyright © 2016年 dadong. All rights reserved.
//

#import "QRScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DDOverView.h"

//扫描区域的宽度
#define ScanViewWidth       200.0f

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
/**
 *  扫码区域
 */
@property (nonatomic, weak) UIImageView *scanView ;
/**
 *  扫描区域上的条状动画view
 */
@property (nonatomic, weak) UIImageView *stripView ;

/**
 *  会话对象
 */
@property (nonatomic, strong)AVCaptureSession *session ;
/**
 *  是否停止动画的标志
 */
@property (nonatomic, assign)BOOL stop ;
@end

@implementation QRScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置扫码区域的那个view
    UIImageView *scanView = [[UIImageView alloc]init];
    _scanView = scanView ;
//    scanView.backgroundColor = [UIColor greenColor];
    CGFloat w = ScanViewWidth ;
    CGFloat x = (DD_SCREEN_WIDTH - w ) / 2 ;
    CGFloat y = 150 ;
    CGFloat h = w ;
    scanView.frame = CGRectMake(x, y, w, h) ;
    [self.view addSubview:scanView];
    
    //扫描区域上面的条形View
    UIImageView *stripView = [[UIImageView alloc]init];
    _stripView = stripView ;
    stripView.backgroundColor = [UIColor redColor];
    stripView.frame = CGRectMake(0, 0, self.scanView.dd_width, 2);
    [self.scanView addSubview:stripView];
    
    //获取摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        if ([device hasFlash] && [device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeAuto];
            [device setFlashMode:AVCaptureFlashModeAuto];
            [device unlockForConfiguration];
        }
    }else{
        DDLog(@"相机不支持扫描，获取没有获取到权限");
        return ;
    }
    
    
    //创建输入流
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
    
    //创建会话对象
    self.session = [[AVCaptureSession alloc]init];
    //设置采集率
    _session.sessionPreset = AVCaptureSessionPresetHigh ;
    
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置聚焦扫码区域
    output.rectOfInterest = [self rectOfInterest];
    
    
    
    //链接两边对象
    [_session addInput:input];
    [_session addOutput:output];
    //增加可支持的类型....----------------> 试验发现，这个必须写在输出流被添加了会话之后，放在之前会导致，可用的metadataObjectType为空
    [self setupMetadataObjectTypes:output];
    
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    preview.frame = self.view.bounds ;
    [self.view.layer insertSublayer:preview above:0];
    
    //扫描区域防止被覆盖
    [self.view bringSubviewToFront:self.scanView];
    
    //添加模糊效果
    [self setupOverView];
    
    [self startScan];
}

//设置摄像头扫描区域
- (CGRect)rectOfInterest
{
    CGFloat height = self.view.dd_height ;
    CGFloat width = self.view.dd_width ;
    CGFloat x = self.scanView.dd_top  / height ;
    CGFloat y = self.scanView.dd_left / width ;
    CGFloat w = self.scanView.dd_height / height ;
    CGFloat h = self.scanView.dd_width / width ;
    
    return CGRectMake(x, y, w, h) ;
}

//设置扫码支持的编码格式
- (void)setupMetadataObjectTypes:(AVCaptureMetadataOutput*)output
{
    
    NSMutableArray *array = [NSMutableArray array];
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        [array addObject:AVMetadataObjectTypeQRCode];
    }
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
        [array addObject:AVMetadataObjectTypeEAN13Code];
    }
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
        [array addObject:AVMetadataObjectTypeEAN8Code];
    }
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
        [array addObject:AVMetadataObjectTypeCode128Code];
    }
    output.metadataObjectTypes = array;
}

- (void)startScan
{
    [self startAnimatation];
    [self.session startRunning];
}

- (void)stopScan
{
    [self.session stopRunning];
    self.stop = YES ;
}

- (void)startAnimatation
{
    typeof(self) __weak weakSelf = self ;
    
    CGFloat beginY = 0 ;
    CGFloat endY = self.scanView.dd_height - self.stripView.dd_height ;
    
    self.stripView.dd_top = beginY ;
    [UIView animateWithDuration:2 animations:^{
        weakSelf.stripView.dd_top = endY ;
    } completion:^(BOOL finished) {
        if (weakSelf.stop == NO) {
            [weakSelf startAnimatation];
        }
    }];
}

#pragma mark - 除扫码区域，其余添加模糊效果
- (void)setupOverView
{
//    //上
//    [self createOverView:CGRectMake(0, 0, self.view.dd_width, self.scanView.dd_top)];
//    
//    //下
//    [self createOverView:CGRectMake(0, self.scanView.dd_bottom, self.view.dd_width, self.view.dd_height - self.scanView.dd_bottom)];
//    
//    //左
//    [self createOverView:CGRectMake(0, self.scanView.dd_top, self.scanView.dd_left, self.scanView.dd_height)];
//    
//    //右
//    [self createOverView:CGRectMake(self.scanView.dd_right, self.scanView.dd_top, self.scanView.dd_left, self.scanView.dd_height)];
    
    DDOverView *overView = [[DDOverView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:overView];
}

#pragma mark - private method
- (UIView *)createOverView:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.2 ;
    [self.view addSubview:view] ;
    return view ;
}

#pragma mark - MetadataOutput的代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        DDLog(@"扫描结果是:\n%@",metadataObject.stringValue);
        
        [self stopScan];//停止扫描
    }
}

- (void)dealloc
{
    DDLog(@"动画会不会影响释放内存");
}
@end
