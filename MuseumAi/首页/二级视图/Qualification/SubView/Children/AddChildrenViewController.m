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

@interface AddChildrenViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrolleView;


@property (strong, nonatomic) IBOutlet UIView *contentView;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;



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
            _timeViewMask.titleLabel.text = @"请选择婚户籍所在地";
            [self showOtherAlertView:@[@"中国香港",@"中国澳门",@"中国台湾"]];///
            
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
        
        [SVProgressHelper dismissWithMsg:@"保存成功 刷新数据！"];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ChooseQualificationTypeViewController class]]) {
                ChooseQualificationTypeViewController *A =(ChooseQualificationTypeViewController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善子女信息"];
    }
}

- (IBAction)otherAddVC:(id)sender {
    [LoginSession sharedInstance].pageType = 2;
    ChooseOtherRealViewController *realController = [[ChooseOtherRealViewController alloc] init];
    [[ProUtils getCurrentVC].navigationController pushViewController:realController animated:YES];
}

@end
