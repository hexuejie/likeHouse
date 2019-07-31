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
#import "ChooseQualificationTypeViewController.h"
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

@property (weak, nonatomic) IBOutlet UIImageView *exchangeImageTwo;

@property (weak, nonatomic) IBOutlet UIImageView *exchangeImageThree;
@property (weak, nonatomic) IBOutlet UIView *threeBackgroundView;//hidden

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midLineTop;//3
@property (weak, nonatomic) IBOutlet UITextField *lysjTextField;
@property (weak, nonatomic) IBOutlet UILabel *lysjTitle;
@property (strong, nonatomic) NSString *tipStr;


@property (strong, nonatomic) NSArray *imageStrArray;

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
    
    
    [self.contentScrolleView addSubview:self.contentView];
    
    [self initCustomData];
    
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

- (void)initCustomData{
    self.title = @"港澳台人士";
    self.tipStr = @"请完善个人信息！";
    self.midLineTop.constant = 0;
    self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 940);
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 940);
    if ([LoginSession sharedInstance].pageType == 1) {//+240
        self.threeBackgroundView.hidden = YES;
        self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 940+240);
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 940+240);
        self.threeBackgroundView.hidden = NO;
        self.tipStr = @"请完善配偶信息！";
        
        NSDictionary *tempDic = [PersonInfo sharedInstance].allmessageDic;
        if (tempDic[@"grxx"][@"jtcy"][@"hyzk"]) {
            if ([tempDic[@"grxx"][@"jtcy"][@"hyzk"] isEqualToString:@"离异"]||[tempDic[@"grxx"][@"jtcy"][@"hyzk"] isEqualToString:@"丧偶"]) {
                self.midLineTop.constant = 51;
                self.lysjTitle.text = [NSString stringWithFormat:@"%@时间",tempDic[@"grxx"][@"jtcy"][@"hyzk"]];
                self.lysjTextField.placeholder  = [NSString stringWithFormat:@"请选择%@",self.lysjTitle.text];
                
                self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 940+240+51);
                self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 940+240+51);
            }
        }
    }else if ([LoginSession sharedInstance].pageType == 2){
        self.tipStr = @"请完善子女信息！";
        self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 940);
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 940);
    }
    
    if (self.personData) {
        
        self.nameTextField.text = self.personData.jtcy.xm;
        self.brithDayTextField.text = self.personData.jtcy.qtzjcsrq;
        self.areaTextField.text = self.personData.jtcy.dq;
       
        self.sexTextField.text = self.personData.jtcy.xb;
        self.numberTextField.text = self.personData.jtcy.zjhm;
        self.changeTimes.text = self.personData.jtcy.hzcs;
        
        if (self.personData.jtcy.lysj.length >0) {
            self.lysjTextField.text = self.personData.jtcy.lysj;
        }
        if (self.personData.jtcy.qtzjyxq.length >0) {
            NSArray  *array = [self.personData.jtcy.qtzjyxq componentsSeparatedByString:@"-"];
            self.beginTimeTextField.text = [array firstObject];
            self.endTimeTextField.text = [array lastObject];
        }
        
        [self.exchangeImageOne setCommenImageUrl:self.personData.zzxx.txzzm];
        [self.exchangeImageTwo setCommenImageUrl:self.personData.zzxx.txzfm];
        [self.exchangeImageThree setCommenImageUrl:self.personData.zzxx.jhz];

        UIButton *_rigthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
        [_rigthButton setTitle:@"删除" forState:UIControlStateNormal];
        [_rigthButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
        [_rigthButton addTarget:self action:@selector(tipView1Clear) forControlEvents:UIControlEventTouchUpInside];
        _rigthButton.titleLabel.font = kSysFont(16);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rigthButton];
    }
}
- (void)tipView1Clear{
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _tipView1.contentTitleLabel.text = [NSString stringWithFormat:@"确定删除该信息？"];
    [_tipView1.sureButton addTarget:self action:@selector(tightViewClear) forControlEvents:UIControlEventTouchUpInside];
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
            [self showCompletionAlertView:@"请选择出生日期"];
            
        }break;
        case 104:{//有效期
            [self showCompletionAlertView:@"请选择有效期开始时间"];
            
        }break;
        case 105:{//有效期
            [self showCompletionAlertView:@"请选择有效期结束时间"];
            
        }break;
        case 106:{//出生日期
            [self showCompletionAlertView:@"请选择离异时间"];
            
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

- (void)showCompletionAlertView:(NSString *)title{
    
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] firstObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.titleLabel.text = title;
    
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
        case 106:{//有效期
            self.lysjTextField.text = dateAndTime;
            
        }break;
        default:
            break;
    }
}




- (IBAction)finishClick:(id)sender {
    if (self.lysjTextField.text.length == 0&&self.lysjTitle.text.length>1) {
        [SVProgressHelper dismissWithMsg: self.tipStr];
        return;
    }
    if (self.nameTextField.text.length == 0||
        self.sexTextField.text.length == 0||
        self.changeTimes.text.length == 0||
        self.areaTextField.text.length == 0||
        self.numberTextField.text.length == 0||
        
        self.brithDayTextField.text.length == 0||
        self.beginTimeTextField.text.length == 0||
        self.endTimeTextField.text.length == 0||
        
        
        !self.exchangeImageOne.image
//        ||!self.exchangeImageTwo.image
        ) {
        [SVProgressHelper dismissWithMsg: self.tipStr];
        return;
    }
    if (
        !self.exchangeImageThree.image&&[LoginSession sharedInstance].pageType == 1
        ) {
        [SVProgressHelper dismissWithMsg:self.tipStr];
        return;
    }
    if([LoginSession sharedInstance].pageType == 1||[LoginSession sharedInstance].pageType == 2){
        [self beginUpLoad];
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
    NSArray *imageArray;
    if (self.exchangeImageTwo.image) {
        imageArray = @[self.exchangeImageOne.image,self.exchangeImageTwo.image
                                ];
        if (self.exchangeImageThree.image) {
            imageArray = @[self.exchangeImageOne.image,self.exchangeImageTwo.image,self.exchangeImageThree.image
                           ];
        }
    }else{
        imageArray = @[self.exchangeImageOne.image
                       ];
        if (self.exchangeImageThree.image) {
            imageArray = @[self.exchangeImageOne.image,self.exchangeImageThree.image
                           ];
        }
    }
    
    [NetWork uploadMoreFileHttpRequestURL:DetailUrlString(@"/upload") RequestPram:@{} arrayImg:imageArray arrayAudio:@[] RequestSuccess:^(id  _Nonnull respoes) {
        if (respoes) {
            weakSelf.imageStrArray = [respoes componentsSeparatedByString:@";"];
            
            if (!self.exchangeImageTwo.image) {
                weakSelf.imageStrArray = [respoes componentsSeparatedByString:@";"];
                if (self.exchangeImageThree.image) {
                    weakSelf.imageStrArray = @[[weakSelf.imageStrArray firstObject],@"",[weakSelf.imageStrArray lastObject]] ;
                }else{
                    weakSelf.imageStrArray = @[[weakSelf.imageStrArray firstObject],@""] ;
                }
            }
            if ([LoginSession sharedInstance].pageType == 1) {//+240
                [weakSelf finishUpInfoPo];
            }else if ([LoginSession sharedInstance].pageType == 2) {//子女
                [weakSelf finishUpInfoZn];
            }else{
               [weakSelf finishUpInfoReal];
            }
        }
    } RequestFaile:^(NSError * _Nonnull erro) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
    } UploadProgress:nil];
}

- (void)finishUpInfoZn{
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{
                           @"yhbh": [NSString stringWithFormat:@"%@",[LoginSession sharedInstance].otherYhbh],
                           @"zjlx":@"港澳台来往大陆通行证",@"xm":self.nameTextField.text
                           ,@"csrq":self.brithDayTextField.text//出生日期
                           ,@"dq":self.areaTextField.text//香港九龙
                           ,@"xb":self.sexTextField.text//性别
                           ,@"zjhm":self.numberTextField.text//证件号码
                           ,@"yxq":[NSString stringWithFormat:@"%@-%@",self.beginTimeTextField.text,self.endTimeTextField.text]//有效期限
                           ,@"hzcs":self.changeTimes.text,//签发机关
                           
                           @"txzzm":self.imageStrArray[0],
                           @"txzfm":self.imageStrArray[1]
                           };
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savezn/new") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [SVProgressHelper dismissWithMsg:response[@"msg"]];
            [weakSelf backRootVC];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)finishUpInfoPo{
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{
                           @"zjlx":@"港澳台来往大陆通行证",@"xm":self.nameTextField.text
                           ,@"csrq":self.brithDayTextField.text//出生日期
                           ,@"dq":self.areaTextField.text//香港九龙
                           ,@"xb":self.sexTextField.text//性别
                           ,@"zjhm":self.numberTextField.text//证件号码
                           ,@"yxq":[NSString stringWithFormat:@"%@-%@",self.beginTimeTextField.text,self.endTimeTextField.text]//有效期限
                           ,@"hzcs":self.changeTimes.text,//签发机关
                           @"lysj":[NSString stringWithFormat:@"%@",self.lysjTextField.text],
                           
                           @"txzzm":self.imageStrArray[0],
                           @"txzfm":self.imageStrArray[1],
                           @"jhz":self.imageStrArray[2]

                           };
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savepo/new") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [SVProgressHelper dismissWithMsg:response[@"msg"]];
            [weakSelf backRootVC];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)finishUpInfoReal{
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{
                           @"zjlx":@"港澳台来往大陆通行证",@"xm":self.nameTextField.text
                           ,@"csrq":self.brithDayTextField.text//出生日期
                           ,@"zz":self.areaTextField.text//香港九龙
                           ,@"xb":self.sexTextField.text//性别
                           ,@"zjhm":self.numberTextField.text//证件号码
                           ,@"yxq":[NSString stringWithFormat:@"%@-%@",self.beginTimeTextField.text,self.endTimeTextField.text]//有效期限
                           ,@"hzcs":self.changeTimes.text,//签发机关
                           
                           @"txzzm":self.imageStrArray[0],
                           @"txzfm":self.imageStrArray[1]
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
    if ([LoginSession sharedInstance].pageType >0) {//+240
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ChooseQualificationTypeViewController class]]) {
                ChooseQualificationTypeViewController *A =(ChooseQualificationTypeViewController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
        return;
    }
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

- (void)tightViewClear{
    NSString *strUrl = @"/api/family/zjw/user/delpo";
    __weak typeof(self) weakSelf = self;
    NSDictionary *parm = @{};
    if ([LoginSession sharedInstance].pageType == 2){
        parm = @{@"yhbh": [NSString stringWithFormat:@"%@",[LoginSession sharedInstance].otherYhbh]};
        strUrl = @"/api/family/zjw/user/delznxx";
    }
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(strUrl) para:parm isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            
            [weakSelf backRootVC];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

@end
