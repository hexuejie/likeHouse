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

@interface AppendThreeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;



@property (nonatomic , assign) NSInteger tagSwitch;
@end

@implementation AppendThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加省直机关社保";
    
    [self.addImageView setBorderWithView];
    
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    _tagSwitch = sender.tag;
    if (sender.tag == 102) {
        _timeViewMask.titleLabel.text = @"请选择缴纳时长";
        [self showCompletionAlertView];
    }else{
        _timeViewMask.titleLabel.text = @"请选择姓名";
        [self showOtherAlertView:@[@"姓名1",@"姓名22",@"姓名3"]];
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
        
        [SVProgressHelper dismissWithMsg:@"保存成功 刷新数据！"];
        [self callBackClick];
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善社保信息!"];
    }
}

@end
