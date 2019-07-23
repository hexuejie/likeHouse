//
//  ChooseAppendViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseAppendViewController.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "UIView+add.h"
#import "PureCamera.h"
#import "RealFinishTipView1.h"
#import "AppendChooseViewController.h"

@interface ChooseAppendViewController ()

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;
@property (nonatomic , assign) NSInteger tagSwitch;

@property (nonatomic , strong)NSArray *imageStrArray;
@property (nonatomic , strong)NSArray *dataArray;
@property (nonatomic , strong)NSMutableArray *nameArray;
@end

@implementation ChooseAppendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加人员";
    
    [self.addImageView setBorderWithView];
   
    
    if (self.addmodel) {
        _oneTextField.text = self.addmodel.tsrclx;
        _twoTextField.text = self.addmodel.xm;
        _threeTextField.text = self.addmodel.zcgzlssc;
        [_addImageView setCommenImageUrl:self.addmodel.tsrczm];
    }
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    _tagSwitch = sender.tag;
    switch (sender.tag) {
        case 101:
        {
            _timeViewMask.titleLabel.text = @"请选择人才类型";
            [self showOtherAlertView:@[@"学历人才",@"引进人才",@"高端人才"]];
        }
            break;
            
        case 102:
        {
            _timeViewMask.titleLabel.text = @"请选择姓名";
            [self showOtherAlertView:self.nameArray];
        }
            break;
            
        default:
            break;
    }
}



- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    switch (_tagSwitch) {
        case 101:{//人才类型
            
            self.oneTextField.text = _timeViewMask.selectedString;
        }break;
        case 102:{//工资流水
            
            self.twoTextField.text = _timeViewMask.selectedString;
            
        }break;
            
            
        default:
            break;
    }
}

- (void)showOtherAlertView:(NSArray *)array{
     _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.customPickArray = array;
    
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)timecancleButtonClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
}

- (IBAction)imageExplameClick:(id)sender {
    RealFinishTipView1 * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 3;
    _tipView1.exampleImage.image = [UIImage imageNamed:@"addPerson_explame"];
}

- (IBAction)saveClick:(id)sender {
//    [SVProgressHelper dismissWithMsg:@"请完善申请人信息!"];
    
    if (self.oneTextField.text.length>0&&
        self.twoTextField.text.length>0&&
        self.threeTextField.text.length>0&&
        self.addImageView.image
        ) {
        
        [self updateLoadImage:nil];
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善申请人信息!"];
    }
    
}



- (void)updateLoadImage:(UIImage *)upImage{
    __weak typeof(self) weakSelf = self;
    NSArray *imageArray = @[self.addImageView.image
                            ];
    [NetWork uploadMoreFileHttpRequestURL:DetailUrlString(@"/upload") RequestPram:@{} arrayImg:imageArray arrayAudio:@[] RequestSuccess:^(id  _Nonnull respoes) {
        if (respoes) {
            weakSelf.imageStrArray = [respoes componentsSeparatedByString:@";"];
            [weakSelf updatePersonData];
        }
    } RequestFaile:^(NSError * _Nonnull erro) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
    } UploadProgress:nil];
}

- (void)updatePersonData{
    
    NSMutableDictionary *pramDic = [NSMutableDictionary new];
    for (NSDictionary *tempDic in _dataArray) {
        if ([tempDic[@"xm"] isEqualToString:self.twoTextField.text]) {
            [pramDic setObject:tempDic[@"yhbh"] forKey:@"yhbh"];
        }
    }
    
    [pramDic setObject:self.oneTextField.text forKey:@"tsrclx"];
    [pramDic setObject:self.threeTextField.text forKey:@"zcgzlssc"];
    
    [pramDic setObject:@"是" forKey:@"sftsrc"];
    [pramDic setObject:self.imageStrArray[0] forKey:@"tsrczm"];

    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savetsrc") para:pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            [SVProgressHelper dismissWithMsg:response[@"msg"]];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[AppendChooseViewController class]]) {
                    AppendChooseViewController *A =(AppendChooseViewController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }
            
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (IBAction)addImageClick:(id)sender {
    [self openCamera];
}

- (void)openCamera

{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        __weak typeof(self) myself = self;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                myself.addImageView.image = ss;
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


///getname
- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/getname") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            weakSelf.dataArray = response[@"data"];
            weakSelf.nameArray = [NSMutableArray new];
            for (NSDictionary *tempDic in weakSelf.dataArray) {
                if (tempDic[@"xm"]) {
                    [weakSelf.nameArray addObject:tempDic[@"xm"]];
                }
            }
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}
@end
