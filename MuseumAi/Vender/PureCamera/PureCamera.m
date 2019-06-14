/*!
 @abstract
 Created by 孙凯峰 on 2016/10/18.
 */
#define KScreenSize [UIScreen mainScreen].bounds.size

#define IsIphone6P KScreenSize.width==414
#define IsIphone6 KScreenSize.width==375
#define IsIphone5S KScreenSize.height==568
#define IsIphone5 KScreenSize.height==568
//456字体大小
#define KIOS_Iphone456(iphone6p,iphone6,iphone5s,iphone5,iphone4s) (IsIphone6P?iphone6p:(IsIphone6?iphone6:((IsIphone5S||IsIphone5)?iphone5s:iphone4s)))
//宽高
#define KIphoneSize_Widith(iphone6) (IsIphone6P?1.104*iphone6:(IsIphone6?iphone6:((IsIphone5S||IsIphone5)?0.853*iphone6:0.853*iphone6)))
#define KIphoneSize_Height(iphone6) (IsIphone6P?1.103*iphone6:(IsIphone6?iphone6:((IsIphone5S||IsIphone5)?0.851*iphone6:0.720*iphone6)))
#import "PureCamera.h"
#import "TOCropViewController.h"
#import "LLSimpleCamera.h"

@interface PureCamera ()<TOCropViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIView *bottomView;
@end

@implementation PureCamera

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self InitializeCamera];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-99, SCREEN_WIDTH, 99)];
    [self.view addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.36];
    
    //拍照按钮
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"PureCamera" ofType:@"bundle"]];
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius =75 / 2.0f;
    UIImage *snapImg = [UIImage imageNamed:@"cameraButton" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.snapButton setImage:snapImg forState:UIControlStateNormal];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    //闪关灯按钮
    self.flashButton = [[UIButton alloc]init];
    
//    self.flashButton.tintColor = [UIColor whiteColor];
    UIImage *flashImg = [UIImage imageNamed:@"camera-flash" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.flashButton setImage:flashImg forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flashed" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
//    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    if([LLSimpleCamera isFrontCameraAvailable] && [LLSimpleCamera isRearCameraAvailable]) {
        //摄像头转换按钮
        self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *switchhImg = [UIImage imageNamed:@"swapButton" inBundle:bundle compatibleWithTraitCollection:nil];
        [self.switchButton setImage:switchhImg forState:UIControlStateNormal];
        [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.switchButton];
        //返回按钮
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *closeImage= [UIImage imageNamed:@"closeButton" inBundle:bundle compatibleWithTraitCollection:nil];
        [self.backButton setImage:closeImage forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backButton];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // snap button to capture image
    
    //判断前后摄像头是否可用
    
    
    // start the camera
    [self.camera start];
}
#pragma mark   ------------- 初始化相机--------------
-(void)InitializeCamera{
    CGRect screenRect = self.view.frame;
    
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"未获取相机权限";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button
{
//    [self.camera togglePosition];
    
    // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            NSLog(@"打开相册");
        }];
    }
    else
    {
        NSLog(@"不能打开相册");
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 拍照完成回调

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"取消");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    _headImageView.image = ;
    
    
    TOCropViewControllerAspectRatio aspectRatioStle = TOCropViewControllerAspectRatioOriginal;
    if (self.aspectRatioStle) {
        aspectRatioStle = self.aspectRatioStle;
    }
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:info[UIImagePickerControllerOriginalImage] aspectRatioStle:aspectRatioStle];
    cropController.delegate = self;
//    [picker dismissViewControllerAnimated:NO completion:^{
//        NSLog(@"选照片");
//    }];

        [picker presentViewController:cropController animated:YES completion:nil];
}


-(void)backButtonPressed:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
//            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
//            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
    
    
}
#pragma mark   -------------拍照--------------

- (void)snapButtonPressed:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    // 去拍照
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        NSLog(@"拍照结束");
        if(!error) {
            TOCropViewControllerAspectRatio aspectRatioStle = TOCropViewControllerAspectRatioOriginal;
            if (self.aspectRatioStle) {
                aspectRatioStle = self.aspectRatioStle;
            }
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image aspectRatioStle:aspectRatioStle];
            cropController.delegate = self;
            [weakSelf presentViewController:cropController animated:YES completion:nil];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.camera.view.frame=self.view.frame;
    
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT-99, SCREEN_WIDTH, 99);
    self.snapButton.frame=CGRectMake((SCREEN_WIDTH-KIphoneSize_Widith(75))/2, SCREEN_HEIGHT-KIphoneSize_Widith(90), KIphoneSize_Widith(75), KIphoneSize_Widith(75));
    self.flashButton.frame=CGRectMake(SCREEN_WIDTH-35-KIphoneSize_Widith(44), SCREEN_HEIGHT-KIphoneSize_Widith(75), KIphoneSize_Widith(45), KIphoneSize_Widith(44));
    
    self.backButton.frame=CGRectMake(15, 15, KIphoneSize_Widith(45), KIphoneSize_Widith(45));//返回
    
    self.switchButton.frame=CGRectMake(35, SCREEN_HEIGHT-KIphoneSize_Widith(75), KIphoneSize_Widith(45), KIphoneSize_Widith(45));//摄像头    图库
//    self.switchButton.hidden = YES;
}
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    self.view.alpha = 0;
    self.fininshcapture(image);
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
