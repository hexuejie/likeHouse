//
//  AppendTwoViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/7.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AppendTwoViewController.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "UIView+add.h"
#import "PureCamera.h"
#import "RealFinishTipView1.h"
#import "AppendChooseViewController.h"

@interface AppendTwoViewController ()

//@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;
@property (nonatomic , strong) NSArray *imageStrArray;
@end

@implementation AppendTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"征收家庭信息";
    
    [self.addImageView setBorderWithView];
    
    
    NSDictionary *tempDic = [PersonInfo sharedInstance].allmessageDic[@"zsjt"];
    self.addmodel = [AddOtherModel mj_objectWithKeyValues:tempDic];
    if (self.addmodel) {
        _timeTextField.text = _addmodel.zsbasj;
        [_addImageView setCommenImageUrl:_addmodel.zsjtzm];
    }
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    
    [self showCompletionAlertView];

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




- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    NSDate *select = _timeViewMask.pickBottom.date;
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc]init];
    selectDateFormatter.dateFormat = @"yyyy.MM.dd";
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    
   self.timeTextField.text = dateAndTime;
}


- (void)showCompletionAlertView{
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] firstObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.titleLabel.text = @"请选择征收备案时间";
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)timecancleButtonClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
}


- (IBAction)saveClick:(id)sender {
//    [SVProgressHelper dismissWithMsg:@"请完善申请人信息!"];
    
    
    if (self.timeTextField.text.length>0&&
        self.addImageView.image
        ) {
        
        [self updateLoadImage:nil];
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善征收信息!"];
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

    [pramDic setObject:self.timeTextField.text forKey:@"zsbasj"];

    [pramDic setObject:@"是" forKey:@"sfzsjt"];
    [pramDic setObject:self.imageStrArray[0] forKey:@"zsjtzm"];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/zsjt") para:pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
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
@end
