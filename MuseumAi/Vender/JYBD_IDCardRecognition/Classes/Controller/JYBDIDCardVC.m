//
//  JYBDIDCardVC.m
//  JYBDAVCapture
//
//  Created by tianxiuping on 2018/8/22.
//  Copyright © 2018年 XP. All rights reserved.
//

#import "JYBDIDCardVC.h"
#import "JYBDNewFormeScaningV.h"
#import "UIAlertController+IDCardExtend.h"
#import "JYBDCardIDInfo.h"

@interface JYBDIDCardVC ()

@property (nonatomic, strong)JYBDScanCardManage *cameraManager;
// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;

@property (nonatomic,assign) BOOL isHaveCamera;//是否有摄像头
@end

@implementation JYBDIDCardVC


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isHaveCamera)
    {
        [self.cameraManager doSomethingWhenWillDisappear];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isHaveCamera)
    {
        self.torchOn = NO;
        [self.cameraManager doSomethingWhenWillAppear];
    }else
    {
        [self showAlert];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"扫描身份证";
    
}

- (void)setIsBehinded:(BOOL)isBehinded{
    _isBehinded = isBehinded;
    self.cameraManager.sessionPreset = AVCaptureSessionPreset1280x720;
    
    if ([self.cameraManager configIDScanManager]) {
        
        self.isHaveCamera = YES;
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:view atIndex:0];
        
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraManager.captureSession];
        preLayer.frame = [UIScreen mainScreen].bounds;
        
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [view.layer addSublayer:preLayer];
        [self.cameraManager startSession];
        
        __weak __typeof__(self) weakSelf = self;
        CGFloat width = [UIScreen mainScreen].bounds.size.width/375.0f;
        // 添加自定义的扫描界面（中间有一个镂空窗口和来回移动的扫描线）
        JYBDNewFormeScaningV * IDCardScaningView = [[JYBDNewFormeScaningV alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 400*width)];
        IDCardScaningView.isBehinded = _isBehinded;
        IDCardScaningView.center = self.view.center;
        //        IDCardScaningView.transform = CGAffineTransformMakeRotation((270.0f * M_PI) / 180.0f);
        IDCardScaningView.scanType = JYBD_IDScanType;
        [self.view addSubview:IDCardScaningView];
        IDCardScaningView.turnOnOrOffClick = ^(BOOL isSelectState)
        {
            [weakSelf turnOnOrOffTorch];
        };
        self.cameraManager.isBehinded = self.isBehinded;
        self.cameraManager.finish = ^(id info, UIImage *image)
        {
            if (weakSelf.finish)
            {
                [weakSelf close];
                weakSelf.finish((JYBDCardIDInfo *)info, [weakSelf ct_imageFromImage:image inRect:CGRectMake((SCREEN_HEIGHT-SCREEN_WIDTH)/2-10, 40, (SCREEN_WIDTH-100)*1.57, SCREEN_WIDTH-100)]);
                
            }
        };
    }
    else
    {
        
    }
}


- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

- (void)showAlert
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   NSLog(@"打开相机失败");
                                   [self close];
                               }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置允许使用摄像设备" okAction:okAction cancelAction:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 打开／关闭手电筒
-(void)turnOnOrOffTorch
{
    self.torchOn = !self.isTorchOn;
    
    if (self.isTorchOn)
    {
        [self.cameraManager setTorchMode:AVCaptureTorchModeOn];
    }
    else
    {
        [self.cameraManager setTorchMode:AVCaptureTorchModeOff];
    }
}
- (JYBDScanCardManage *)cameraManager {
    if (!_cameraManager)
    {
        _cameraManager = [[JYBDScanCardManage alloc] init];
        
    }
    return _cameraManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
