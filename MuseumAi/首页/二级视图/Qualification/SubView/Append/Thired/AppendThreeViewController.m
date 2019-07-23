//
//  AppendThreeViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/7.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AppendThreeViewController.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "UIView+add.h"
#import "PureCamera.h"
#import "RealFinishTipView1.h"
#import "AppendChooseViewController.h"

@interface AppendThreeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;

@property (nonatomic , strong) NSArray *imageStrArray;
@property (nonatomic , strong)NSArray *dataArray;
@property (nonatomic , strong)NSMutableArray *nameArray;

@property (nonatomic , assign) NSInteger tagSwitch;
@end

@implementation AppendThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加省直机关社保";
    
    [self.addImageView setBorderWithView];
    
    NSDictionary *tempDic = [[PersonInfo sharedInstance].allmessageDic[@"szsbList"] firstObject];
    self.addmodel = [AddOtherModel mj_objectWithKeyValues:tempDic];
    if (self.addmodel) {
        _nameTextField.text = _addmodel.xm;
        _timeTextField.text = _addmodel.szsb;
        [_addImageView setCommenImageUrl:_addmodel.szssbzm];
    }
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    _tagSwitch = sender.tag;
    if (sender.tag == 102) {
        _timeViewMask.titleLabel.text = @"请选择缴纳时长";
        [self showCompletionAlertView];
    }else{
        _timeViewMask.titleLabel.text = @"请选择姓名";
        [self showOtherAlertView:self.nameArray];
    }
}

- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    if (_tagSwitch == 102) {
        NSDate *select = _timeViewMask.pickBottom.date;
        NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc]init];
        selectDateFormatter.dateFormat = @"yyyy.MM.dd";
        NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
        self.timeTextField.text = dateAndTime;
    }else{
       self.nameTextField.text = _timeViewMask.selectedString;
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


- (IBAction)saveClick:(id)sender {
//    [SVProgressHelper dismissWithMsg:@"请完善社保信息!"];
    
    if (self.nameTextField.text.length>0&&
        self.timeTextField.text.length>0&&
        self.addImageView.image
        ) {
        
        [self updateLoadImage:nil];
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善社保信息!"];
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
        if ([tempDic[@"xm"] isEqualToString:self.nameTextField.text]) {
            [pramDic setObject:tempDic[@"yhbh"] forKey:@"yhbh"];
        }
    }
    
    [pramDic setObject:self.timeTextField.text forKey:@"szssb"];
    [pramDic setObject:self.imageStrArray[0] forKey:@"szssbzm"];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/szsb") para:pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
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

@end
