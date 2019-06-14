//
//  ChooseAddMyselfVC.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseAddMyselfVC.h"
#import "UIView+add.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "PureCamera.h"
#import "ChooseQualificationTypeViewController.h"

@interface ChooseAddMyselfVC ()

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;
@property (nonatomic , assign) NSInteger tagSwitch;
@end

@implementation ChooseAddMyselfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"完善申请人信息";
    [self.addImageView setBorderWithView];
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    _tagSwitch = sender.tag;
    switch (sender.tag) {
        case 101:
            {
                _timeViewMask.titleLabel.text = @"请选择家庭户口类型";
                [self showOtherAlertView:@[@"集体户口",@"家庭户口"]];
            }
            break;
            
        case 102:
        {
            _timeViewMask.titleLabel.text = @"请选择婚姻状况";
            [self showOtherAlertView:@[@"已婚",@"未婚",@"离异",@"丧偶"]];
        }
            break;
            
        case 103:
        {
            _timeViewMask.titleLabel.text = @"请选择户籍所在地";
            [self showOtherAlertView:@[@"已婚",@"未婚",@"离异",@"丧偶"]];
        }
            break;
            
        default:
            break;
    }
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


- (IBAction)saveClick:(id)sender {
    
    
    if (self.oneTextField.text.length>0&&
        self.twoTextField.text.length>0&&
        self.threeTextField.text.length>0&&
        self.addImageView.image
        ) {
        
        [SVProgressHelper dismissWithMsg:@"保存成功 刷新数据！"];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ChooseQualificationTypeViewController class]]) {
                ChooseQualificationTypeViewController *A =(ChooseQualificationTypeViewController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善申请人信息!"];
    }
}

- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
//    NSDate *select = _timeViewMask.pickBottom.date;
//    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc]init];
//    selectDateFormatter.dateFormat = @"yyyy.MM.dd";
//    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    
    switch (_tagSwitch) {
        case 101:{//地区
            self.oneTextField.text = _timeViewMask.selectedString;
            
        }break;
        case 102:{//性别
            self.twoTextField.text = _timeViewMask.selectedString;
            
        }break;
            
        case 103:{//出生日期
            self.threeTextField.text = _timeViewMask.selectedString;
            
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
@end
