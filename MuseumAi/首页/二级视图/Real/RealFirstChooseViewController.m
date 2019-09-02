//
//  RealFirstChooseViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/29.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RealFirstChooseViewController.h"
#import "RealFinishTipView1.h"
#import "ChooseOtherRealViewController.h"
#import "PureCamera.h"
#import "JYBDIDCardVC.h"

#define ChangeIDViewHeight (176+23)
#define IDViewHeightFirst 500
#define IDViewHeightSecond 338

@interface RealFirstChooseViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollew;

@property (strong, nonatomic) IBOutlet UIView *headerTipView;

@property (strong, nonatomic) IBOutlet UIView *changeView;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (strong, nonatomic) UIView *changeView2;


@property (strong, nonatomic) IBOutlet UIView *frontAllView;
@property (weak, nonatomic) IBOutlet UIView *frontBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (weak, nonatomic) IBOutlet UITextField *brithdayTExtField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberIdTextField;


@property (strong, nonatomic) IBOutlet UIView *behindAllView;
@property (weak, nonatomic) IBOutlet UIView *behindBgView;
@property (weak, nonatomic) IBOutlet UITextField *organizationTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *frontImage;
@property (weak, nonatomic) IBOutlet UIImageView *behindImage;

@property (strong, nonatomic) NSArray *imageStrArray;
//@property (strong, nonatomic) NSString *behindImageStr;

/** 倒计时 */
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) RealFinishTipView1 *tipView1;

@property (assign, nonatomic) BOOL chooseFonted;
@property (assign, nonatomic) BOOL chooseBehinded;
@end

@implementation RealFirstChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实名认证";
    
    
    [self initCustomView];
    
    self.chooseFonted = NO;
    self.chooseBehinded = NO;
    [self updateCustomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.contentScrollew addGestureRecognizer:tableViewGesture];

}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}

- (void)initCustomView{
    self.contentScrollew.alwaysBounceVertical = YES;
    self.changeView2 = [self copyAView:self.changeView];
    
    CGFloat maign = 23;
    CGFloat headerHeight = 0;
    self.headerTipView.hidden = YES;
//    self.headerTipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);////116
    self.changeView.frame = CGRectMake(45, headerHeight+maign, SCREEN_WIDTH-95, 176);
    self.changeView2.frame = CGRectMake(45, headerHeight+maign*2 +176, SCREEN_WIDTH-95, 176);
    
    self.frontAllView.frame = CGRectMake(0, headerHeight, SCREEN_WIDTH-0, IDViewHeightFirst);
    self.behindAllView.frame = CGRectMake(0, headerHeight+maign +176, SCREEN_WIDTH-0, IDViewHeightSecond);
    
    self.contentScrollew.contentSize = CGSizeMake(SCREEN_WIDTH, 515);
    
    UIButton *button2 = [self.changeView2 viewWithTag:998];
    [button2 setTitle:@"点击扫描本人身份证反面" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeBhindClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setBorderWithView:self.changeView];
    [self setBorderWithView:self.changeView2];
    [self setBorderWithView:self.frontBgView];
    [self setBorderWithView:self.behindBgView];
}



- (void)updateCustomView{
    [self.contentScrollew.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentScrollew addSubview:self.headerTipView];
    CGFloat maign = 23;
    CGFloat headerHeight = 0;
    self.changeView2.frame = CGRectMake(45, headerHeight+maign*2 +176, SCREEN_WIDTH-95, 176);
    self.behindAllView.frame = CGRectMake(0, headerHeight+maign +176, SCREEN_WIDTH-0, IDViewHeightSecond);
    
    CGFloat allHeight = 515;
    if (self.chooseFonted) {
        allHeight = allHeight-ChangeIDViewHeight  +IDViewHeightFirst;
        [self.contentScrollew addSubview:self.frontAllView];
        self.changeView2.frame = CGRectMake(45, headerHeight+maign +IDViewHeightFirst, SCREEN_WIDTH-95, 176);
        self.behindAllView.frame = CGRectMake(0, headerHeight+maign +IDViewHeightFirst, SCREEN_WIDTH-0, IDViewHeightSecond);
    }else{
        [self.contentScrollew addSubview:self.changeView];
    }
    if (self.chooseBehinded) {
        allHeight = allHeight-176  +IDViewHeightSecond;
        [self.contentScrollew addSubview:self.behindAllView];
    }else{
        [self.contentScrollew addSubview:self.changeView2];
    }
    
    self.contentScrollew.contentSize = CGSizeMake(SCREEN_WIDTH, allHeight);
}

- (IBAction)changeIdClick:(id)sender {

    __weak __typeof__(self) weakSelf = self;

    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.isBehinded = NO;
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {
        weakSelf.chooseFonted =  YES;
        [weakSelf updateCustomView];
        self.frontImage.image = image;

        self.nameTextField.text = info.name;
        self.sexTextField.text = info.gender;
        self.typeTextField.text = info.nation;
        self.addressTextField.text = info.address;
        self.numberIdTextField.text = info.num;
        self.brithdayTExtField.text = [info.num substringWithRange:NSMakeRange(6, 8)];

    };
    [self presentViewController:AVCaptureVC animated:YES completion:nil];
    
}
- (IBAction)changeBhindClick:(id)sender {
    __weak __typeof__(self) weakSelf = self;

    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.isBehinded = YES;
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {
        weakSelf.chooseBehinded =  YES;
        [weakSelf updateCustomView];
        self.behindImage.image = image;

        self.organizationTextField.text = info.issue;
        self.timeTextField.text = info.valid;
    };
    [self presentViewController:AVCaptureVC animated:YES completion:nil];
}


- (IBAction)otherChooseClick:(id)sender {
    
    [self.navigationController pushViewController:[ChooseOtherRealViewController new] animated:YES];
}


- (IBAction)finishClick:(id)sender {
   
    if (self.nameTextField.text.length == 0||
        self.sexTextField.text.length == 0||
        self.typeTextField.text.length == 0||
        self.brithdayTExtField.text.length == 0||
        
        self.addressTextField.text.length == 0||
        self.numberIdTextField.text.length == 0||
        self.behindImage.image == nil||
        self.frontImage.image == nil
        ) {
        [SVProgressHelper dismissWithMsg: @"请完善个人信息！"];
        return;
    }
    
   _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 0;
    
    _tipView1.textField1.text = self.nameTextField.text;
    
    _tipView1.textField2.text = self.sexTextField.text;
    _tipView1.textField3.text = self.typeTextField.text;
    _tipView1.textField4.text = self.brithdayTExtField.text;
    _tipView1.textField5.text = self.addressTextField.text;
    _tipView1.textField6.text = self.numberIdTextField.text;
    
    _tipView1.textField7.text = self.organizationTextField.text;
    _tipView1.textField8.text = self.timeTextField.text;
    
    [self startCount];
    _tipView1.sureButton.userInteractionEnabled = NO;
    [_tipView1.sureButton addTarget:self action:@selector(beginUpLoad) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sureButtonClick{
    [_tipView1 customHidden];
    
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 1;
    
    [_tipView1.sureButton addTarget:self action:@selector(backRootVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginUpLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self updateLoadImage:nil];
}

- (void)updateLoadImage:(UIImage *)upImage{
    
    __weak typeof(self) weakSelf = self;
    //上传图片
    NSArray *imageArray = @[self.frontImage.image
                            ,self.behindImage.image
                            ];
    
    [NetWork uploadMoreFileHttpRequestURL:DetailUrlString(@"/upload") RequestPram:@{} arrayImg:imageArray arrayAudio:@[] RequestSuccess:^(id  _Nonnull respoes) {
        if (respoes) {
            weakSelf.imageStrArray = [respoes componentsSeparatedByString:@";"];
            [weakSelf finishUpInfo
             ];
        }
    } RequestFaile:^(NSError * _Nonnull erro) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
    } UploadProgress:nil];
}

- (void)finishUpInfo{
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{
                           @"zjlx":@"身份证",@"xm":self.nameTextField.text,@"mz":self.typeTextField.text//民族
                           ,@"csrq":self.brithdayTExtField.text//出生日期
                           ,@"zz":self.addressTextField.text
                           ,@"xb":self.sexTextField.text
                           ,@"zjhm":self.numberIdTextField.text
                           ,@"yxq":self.timeTextField.text
                           ,@"qfjg":self.organizationTextField.text,
                           
                           @"sfzzm":[self.imageStrArray firstObject],//http://app.cszjw.net:11000/img?path=/2019/04/05/155446198745056156623334787220109147.jpg
                           @"sfzfm":[self.imageStrArray lastObject]
                           };
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/newverify") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [LoginSession sharedInstance].rzzt = @"0";
            [weakSelf sureButtonClick];
        }else{
             [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}


- (void)backRootVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)startCount {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didOneSecReached:) userInfo:nil repeats:YES];
    self.count = 3;
    
    [_tipView1.sureButton setTitle:@"3s后可提交" forState:UIControlStateNormal];
    _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
}
- (void)didOneSecReached:(id)sender {
    
    if (self.count > 0) {
        self.count--;
        NSString *countStr = [NSString stringWithFormat:@"%lds后可提交",self.count];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateNormal];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateSelected];
        _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
        if (self.count == 0) {
            
            _tipView1.sureButton.userInteractionEnabled = YES;
            [_tipView1.sureButton setTitle:@"确认提交" forState:UIControlStateNormal];
            [_tipView1.sureButton setTitle:@"确认提交" forState:UIControlStateSelected];
            _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xC0905D);
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)setBorderWithView:(UIView *)view{
    CGRect tempSize = CGRectMake(0,0,SCREEN_WIDTH-90, view.bounds.size.height);
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = kUIColorFromRGB(0xEBDECF).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:tempSize].CGPath;
    
    border.frame = tempSize;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    [view.layer addSublayer:border];
}
- (UIView *)copyAView:(UIView *)view
{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    

    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)keyboardChange:(NSNotification *)note{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyHeight =  [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    self.view.frame = CGRectMake(0, -keyHeight/2, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
