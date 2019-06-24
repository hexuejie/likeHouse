//
//  RealChooseHKViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/30.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RealChooseHKViewController.h"
#import "UIView+add.h"
#import "RealFinishTipView1.h"
#import "ReleaseHomeworkTimeViewMask.h"

#import "PureCamera.h"

@interface RealChooseHKViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolleView;


@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeTimes;

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *brithDayTextField;

@property (weak, nonatomic) IBOutlet UITextField *beginTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;


//图片
@property (weak, nonatomic) IBOutlet UIImageView *exchangeImageOne;
@property (strong, nonatomic) NSString *exchangeImageOneStr;
@property (weak, nonatomic) IBOutlet UIImageView *exchangeImageTwo;
@property (strong, nonatomic) NSString *exchangeImageTwoStr;

@property (strong, nonatomic) NSString *exchangeImageThreeStr;
@property (weak, nonatomic) IBOutlet UIImageView *exchangeImageThree;
@property (weak, nonatomic) IBOutlet UIView *threeBackgroundView;//hidden


/** 倒计时 */
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) RealFinishTipView1 *tipView1;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;

@property (nonatomic , assign) NSInteger tagSwitch;


@end

@implementation RealChooseHKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"港澳台人士";
    
    [self.contentScrolleView addSubview:self.contentView];
    
    if ([LoginSession sharedInstance].pageType == 1) {//+240
        self.threeBackgroundView.hidden = YES;
        self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 940+240);
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 940+240);
        self.threeBackgroundView.hidden = NO;
    }else{
        self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 940);
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 940);
    }
    [self.exchangeImageOne setBorderWithView];
    [self.exchangeImageTwo setBorderWithView];
    [self.exchangeImageThree setBorderWithView];
    
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.contentScrolleView addGestureRecognizer:tableViewGesture];
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}



- (IBAction)chooseSwitchCick:(UIButton *)sender {
    _tagSwitch = sender.tag;
    switch (sender.tag) {
        case 101:{//地区
            [self showOtherAlertView:@[@"中国香港",@"中国澳门",@"中国台湾"]];
            
        }break;
        case 102:{//性别
            [self showOtherAlertView:@[@"男",@"女"]];
            
        }break;
        case 103:{//出生日期
            [self showCompletionAlertView];
            
        }break;
        case 104:{//有效期
            [self showCompletionAlertView];
            
        }break;
        case 105:{//有效期
            [self showCompletionAlertView];
            
        }break;
            
        default:
            break;
    }
    
    
}

- (IBAction)changeOneClick:(id)sender {
    _tagSwitch = 106;
    [self openCamera];
}

- (IBAction)changeTwoClick:(id)sender {
    _tagSwitch = 107;
    [self openCamera];
}

- (IBAction)changeTreeClick:(id)sender {
    _tagSwitch = 108;
    [self openCamera];
}

- (void)openCamera

{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        __weak typeof(self) myself = self;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                if (myself.tagSwitch == 106) {
                    myself.exchangeImageOne.image = ss;
//                    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                }else if (myself.tagSwitch == 107) {
                    myself.exchangeImageTwo.image = ss;
//                    myself.exchangeImageTwo.layer.borderColor = [UIColor clearColor].CGColor;
                }else if (myself.tagSwitch == 108) {
                    myself.exchangeImageThree.image = ss;
                    //                    myself.exchangeImageTwo.layer.borderColor = [UIColor clearColor].CGColor;
                }
            }
        };
        [myself presentViewController:homec
                             animated:NO
                           completion:^{
                           }];
    } else {
        NSLog(@"相机调用失败");
    }
}






- (void)showOtherAlertView:(NSArray *)array{
    
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.customPickArray = array;
    if (array.count == 2) {
        _timeViewMask.titleLabel.text = @"请选择性别";
    }
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showCompletionAlertView{
    
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] firstObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)timecancleButtonClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
}

- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    NSDate *select = _timeViewMask.pickBottom.date;
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc]init];
    selectDateFormatter.dateFormat = @"yyyy.MM.dd";
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    
    switch (_tagSwitch) {
        case 101:{//地区
            self.areaTextField.text = _timeViewMask.selectedString;
            
        }break;
        case 102:{//性别
            self.sexTextField.text = _timeViewMask.selectedString;
            
        }break;
            
        case 103:{//出生日期
            self.brithDayTextField.text = dateAndTime;
            
        }break;
        case 104:{//有效期
            self.beginTimeTextField.text = dateAndTime;
            
        }break;
        case 105:{//有效期
            self.endTimeTextField.text = dateAndTime;
            
        }break;
        default:
            break;
    }
}




- (IBAction)finishClick:(id)sender {
    if (self.nameTextField.text.length == 0||
        self.sexTextField.text.length == 0||
        self.changeTimes.text.length == 0||
        self.areaTextField.text.length == 0||
        self.numberTextField.text.length == 0||
        
        self.brithDayTextField.text.length == 0||
        self.beginTimeTextField.text.length == 0||
        self.endTimeTextField.text.length == 0||
        
        
        !self.exchangeImageOne.image ||
        !self.exchangeImageTwo.image
        ) {
        [SVProgressHelper dismissWithMsg: @"请完善个人信息！"];
        return;
    }
    if (
        !self.exchangeImageThree.image&&[LoginSession sharedInstance].pageType == 1
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
    _tipView1.textLabel3.text = @"地区";
    _tipView1.textField3.text = self.areaTextField.text;
    _tipView1.textField4.text = self.brithDayTextField.text;
    
    _tipView1.textLabel5.text = @"证件号码";
    _tipView1.textField5.text = self.numberTextField.text;
    _tipView1.textLabel6.text = @"换证次数";
    _tipView1.textField6.text = self.changeTimes.text;
    _tipView1.textLabel7.text = @"有效期限";
    _tipView1.textField7.text = [NSString stringWithFormat:@"%@-%@",self.beginTimeTextField.text,self.endTimeTextField.text];
    
    _tipView1.textLabel8.text = @"";
    _tipView1.textField8.hidden = YES;

    [self startCount];
    _tipView1.sureButton.userInteractionEnabled = NO;
    [_tipView1.sureButton addTarget:self action:@selector(beginUpLoad) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginUpLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self updateLoadImage:self.exchangeImageOne.image];

}


- (void)updateLoadImage:(UIImage *)upImage{
    __weak typeof(self) weakSelf = self;
    //上传图片
    AFHTTPSessionManager*  manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html",@"image/jpeg",nil];
    [manager POST:@"http://10.3.61.154:80/app/file/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(upImage, 0.8);
        [formData appendPartWithFileData:data name:@"file" fileName:@".jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (upImage == weakSelf.exchangeImageOne.image) {
            weakSelf.exchangeImageOneStr = responseObject[@"data"][@"src"];
        }else if (upImage == weakSelf.exchangeImageTwo.image) {
            weakSelf.exchangeImageTwoStr = responseObject[@"data"][@"src"];
        }else if (upImage == weakSelf.exchangeImageThree.image) {
            weakSelf.exchangeImageThreeStr = responseObject[@"data"][@"src"];
        }
        if (!weakSelf.exchangeImageOneStr) {
            [self updateLoadImage:self.exchangeImageOne.image];
        }else if(!weakSelf.exchangeImageTwoStr) {
            [self updateLoadImage:self.exchangeImageTwo.image];
        }
//        else if(!weakSelf.exchangeImageThreeStr&&[LoginSession sharedInstance].pageType == 1) {
//            [self updateLoadImage:self.exchangeImageThree.image];
//        }
        
        else{
            [self finishUpInfo];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)finishUpInfo{
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{@"verifyType":@"1",//2外籍
                           @"zjlx":@"港澳台来往大陆通行证",@"xm":self.nameTextField.text
                           ,@"csrq":self.brithDayTextField.text//出生日期
                           ,@"zz":self.areaTextField.text//香港九龙
                           ,@"xb":self.sexTextField.text//性别
                           ,@"zjhm":self.numberTextField.text//证件号码
                           ,@"yxq":[NSString stringWithFormat:@"%@-%@",self.beginTimeTextField.text,self.endTimeTextField.text]//有效期限
//                           ,@"qfjg":self.organizationTextField.text,//签发机关
                           ,@"hzcs":self.changeTimes.text,//签发机关
                           
                           @"txzzm":self.exchangeImageOneStr,
                           @"txzfm":self.exchangeImageTwoStr
                           };
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/newverify") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            
            [weakSelf sureButtonClick];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}


- (void)sureButtonClick{
    [_tipView1 customHidden];
    
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 1;
    
    [_tipView1.sureButton addTarget:self action:@selector(backRootVC) forControlEvents:UIControlEventTouchUpInside];
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


- (IBAction)exampleOne:(id)sender {
    RealFinishTipView1 * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 3;
}

- (IBAction)exampleTwo:(id)sender {
    RealFinishTipView1 * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 4;
}
@end
