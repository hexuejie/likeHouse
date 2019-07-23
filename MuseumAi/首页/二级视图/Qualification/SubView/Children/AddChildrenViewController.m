//
//  AddChildrenViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AddChildrenViewController.h"
#import "UIView+add.h"
//#import "RealFinishTipView1.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "PureCamera.h"
#import "ChooseQualificationTypeViewController.h"
#import "ChooseOtherRealViewController.h"
#import "MOFSPickerManager.h"

@interface AddChildrenViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolleView;


@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;

@property (nonatomic , strong) NSArray *imageStrArray;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *exchangeImage;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;


@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;

@property (nonatomic , assign) NSInteger tagSwitch;

@end

@implementation AddChildrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加子女信息";
    
    [self.contentScrolleView addSubview:self.contentView];
    self.contentScrolleView.contentSize = CGSizeMake(SCREEN_WIDTH, 660-116);
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 660-116);
    [self.exchangeImage setBorderWithView];
    
    
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.contentScrolleView addGestureRecognizer:tableViewGesture];
    
    [self initCustomData];
}

- (void)initCustomData{
    
    if (self.personData) {
        
        self.nameTextField.text = self.personData.jtcy.xm;
        self.typeTextField.text = self.personData.jtcy.hjfl;
        self.areaTextField.text = self.personData.jtcy.hjszd;
        
        self.sexTextField.text = self.personData.jtcy.xb;
        self.numberTextField.text = self.personData.jtcy.zjhm;
        
        [self.exchangeImage setCommenImageUrl:self.personData.zzxx.hkb];
        
        UIButton *_rigthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
        [_rigthButton setTitle:@"删除" forState:UIControlStateNormal];
        [_rigthButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
        [_rigthButton addTarget:self action:@selector(tightViewClear) forControlEvents:UIControlEventTouchUpInside];
        _rigthButton.titleLabel.font = kSysFont(16);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rigthButton];
    }
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}

- (IBAction)changeButtonClick:(UIButton *)sender {
    _tagSwitch = sender.tag;
    switch (sender.tag) {
        case 101:{
            _timeViewMask.titleLabel.text = @"请选择性别";
            [self showOtherAlertView:@[@"男",@"女"]];
            
        }break;
        case 102:{
            _timeViewMask.titleLabel.text = @"请选择家庭户口类型";
            [self showOtherAlertView:@[@"集体户口",@"家庭户口"]];
            
        }break;
            
        case 103:{//地区
//            _timeViewMask.titleLabel.text = @"请选择婚户籍所在地";
//            [self showOtherAlertView:@[@"中国香港",@"中国澳门",@"中国台湾"]];///
            //湖南省-长沙市-岳麓区
            NSString *string = self.areaTextField.text;
            [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultAddress:string title:@"请选择户籍所在地" cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
                self.areaTextField.text = address;
                NSLog(@"%@", zipcode);
                
            } cancelBlock:^{
                
            }];
        }break;
            
        default:
            break;
    }
}




- (void)showOtherAlertView:(NSArray *)array{
    
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.customPickArray = array;
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)timecancleButtonClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
}

- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
 
    switch (_tagSwitch) {
        case 101:{//性别
            self.sexTextField.text = _timeViewMask.selectedString;
            
        }break;
        case 102:{//类型
            self.typeTextField.text = _timeViewMask.selectedString;
            
        }break;
            
        case 103:{//出生日期
            self.areaTextField.text = _timeViewMask.selectedString;
            
        }break;
        
        default:
            break;
    }
}
- (IBAction)changeImageClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        __weak typeof(self) myself = self;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                myself.exchangeImage.image = ss;
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


- (IBAction)finishSaveClick:(id)sender {

    
    if (self.nameTextField.text.length>0&&
        self.numberTextField.text.length>0&&
        self.typeTextField.text.length>0&&
        self.areaTextField.text.length>0&&
        self.sexTextField.text.length>0&&
        self.exchangeImage.image
        ) {
        
        [self updateLoadImage:nil];
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善子女信息"];
    }
}

- (IBAction)otherAddVC:(id)sender {
    [LoginSession sharedInstance].pageType = 2;
    ChooseOtherRealViewController *realController = [[ChooseOtherRealViewController alloc] init];
    [[ProUtils getCurrentVC].navigationController pushViewController:realController animated:YES];
}


- (void)updateLoadImage:(UIImage *)upImage{
    __weak typeof(self) weakSelf = self;
    //上传图片
    NSArray *imageArray = @[self.exchangeImage.image
                            ];
 
    [NetWork uploadMoreFileHttpRequestURL:DetailUrlString(@"/upload") RequestPram:@{} arrayImg:imageArray arrayAudio:@[] RequestSuccess:^(id  _Nonnull respoes) {
        if (respoes) {
            weakSelf.imageStrArray = [respoes componentsSeparatedByString:@";"];
            [weakSelf finishUpInfoZn];
        }
    } RequestFaile:^(NSError * _Nonnull erro) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
    } UploadProgress:nil];
}

- (void)finishUpInfoZn{
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{@"zjlx":@"户口薄"
                           ,@"yhbh":[NSString stringWithFormat:@"%@",[LoginSession sharedInstance].otherYhbh]
                           ,@"xm":self.nameTextField.text
                           ,@"hjfl":self.typeTextField.text//出生日期
                    
                           ,@"xb":self.sexTextField.text//性别
                           ,@"zjhm":self.numberTextField.text//证件号码
                           ,@"hjszd":self.areaTextField.text//证件号码
                           
                           ,@"sfyfyq":@"是"
                           ,@"hkb":self.imageStrArray[0]
                           };
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savezn/new") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            
            [SVProgressHelper dismissWithMsg:response[@"msg"]];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ChooseQualificationTypeViewController class]]) {
                    ChooseQualificationTypeViewController *A =(ChooseQualificationTypeViewController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}
///listznxx

- (void)tightViewClear{
    NSString *strUrl = @"/api/family/zjw/user/delpo";
    __weak typeof(self) weakSelf = self;
    NSDictionary *parm = @{};
        parm = @{@"yhbh": [NSString stringWithFormat:@"%@",[LoginSession sharedInstance].otherYhbh]};
        strUrl = @"/api/family/zjw/user/delznxx";
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(strUrl) para:parm isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [SVProgressHelper dismissWithMsg:@"删除成功！"];
            [weakSelf callBackClick];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}
@end
