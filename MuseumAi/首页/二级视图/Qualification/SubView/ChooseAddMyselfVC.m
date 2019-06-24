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
#import "MOFSPickerManager.h"

@interface ChooseAddMyselfVC ()

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (strong, nonatomic) NSString *addImageViewStr;
@property (strong, nonatomic) NSDictionary *dataDic;

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
            //湖南省-长沙市-岳麓区
            NSString *string = self.threeTextField.text;
            [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultAddress:string title:@"请选择户籍所在地" cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
                self.threeTextField.text = address;
                NSLog(@"%@", zipcode);
                
            } cancelBlock:^{
                
            }];
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
        
        [self updateLoadImage:self.addImageView.image];
        
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善申请人信息!"];
    }
}

- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    switch (_tagSwitch) {
        case 101:{//地区
            self.oneTextField.text = _timeViewMask.selectedString;
            
        }break;
        case 102:{//性别
            self.twoTextField.text = _timeViewMask.selectedString;
            
        }break;
            
        case 103:{//
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
        if (responseObject[@"data"][@"src"]) {
            weakSelf.addImageViewStr = responseObject[@"data"][@"src"];
            [self updatePersonData];
        }else{
            [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)updatePersonData{
    if (![LoginSession sharedInstance].yhbh) {
        [LoginSession sharedInstance].yhbh = @"";
    }
        __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{@"hjfl":self.oneTextField.text
                           ,@"hjszd":self.threeTextField.text
                           ,@"yhbh":[LoginSession sharedInstance].yhbh
                           ,@"hyzk":self.twoTextField.text
                           ,@"hkb":self.addImageViewStr
                           };

    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savemy/new") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
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

- (void)reloadData {
    __weak typeof(self) weakSelf = self;

    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/allmessage/new") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            weakSelf.dataDic = response[@"data"];
            NSDictionary *tempgrxx = weakSelf.dataDic[@"grxx"];
            if (![Utility is_empty:tempgrxx[@"jtcy"][@"hjfl"]]) {//地址
                self.oneTextField.text = tempgrxx[@"jtcy"][@"hjfl"];
            }
            if (![Utility is_empty:tempgrxx[@"jtcy"][@"hyzk"]]) {//地址
                self.twoTextField.text = tempgrxx[@"jtcy"][@"hyzk"];
            }
            if (![Utility is_empty:tempgrxx[@"jtcy"][@"hjszd"]]) {//地址
                self.threeTextField.text = tempgrxx[@"jtcy"][@"hjszd"];
            }
            if (![Utility is_empty:tempgrxx[@"zzxx"][@"hkb"]]) {//图片
                [self.addImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,tempgrxx[@"zzxx"][@"hkb"]]]];
            }
     
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}
@end
