//
//  RealChooseForeignViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/31.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RealChooseForeignViewController.h"
#import "UIView+add.h"
#import "RealFinishTipView1.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "XWCountryCodeController.h"
#import "PureCamera.h"

@interface RealChooseForeignViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolleView;


@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *changeTimes;//证件号码


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

/** 倒计时 */
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) RealFinishTipView1 *tipView1;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;

@property (nonatomic , assign) NSInteger tagSwitch;
@end

@implementation RealChooseForeignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"外籍人士";
    
    [self.contentScrolleView addSubview:self.contentView];
    
    if ([LoginSession sharedInstance].pageType == 1) {//+240
        self.threeBackgroundView.hidden = YES;
        self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 810+240);
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 810+240);
        self.threeBackgroundView.hidden = NO;
    }else{
        self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 810);
        self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 810);
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
        case 101:{//国家
            
            XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];

            /// 使用 Block 回调
            __weak __typeof(self)weakSelf = self;
            countryCodeVC.returnCountryCodeBlock = ^(NSString *countryName, NSString *code) {
//                __strong __typeof(weakSelf) strongSelf = weakSelf;
//                strongSelf->showCodeLB.text = [NSString stringWithFormat:@"国家: %@  代码: %@",countryName,code];
                weakSelf.areaTextField.text = countryName;
            };
            [self.navigationController pushViewController:countryCodeVC animated:YES];
            
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
//            self.areaTextField.text = _timeViewMask.selectedString;
           
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
        
        self.brithDayTextField.text.length == 0||
        self.beginTimeTextField.text.length == 0||
        
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
    
    [self startCount];
    _tipView1.sureButton.userInteractionEnabled = NO;
    [_tipView1.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    _tipView1.sureType = 5;
}

- (IBAction)exampleTwo:(id)sender {
    RealFinishTipView1 * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 6;
}
@end
