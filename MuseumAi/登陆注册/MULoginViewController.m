//
//  MULoginViewController.m
//  MuseumAi
//
//  Created by Kingo on 2018/9/25.
//  Copyright © 2018年 Weizh. All rights reserved.
//

#import "MULoginViewController.h"
#import "MURegisterViewController.h"
#import "MUForgetPwdViewController.h"
#import "WXApi.h"
#import "MUForgetPwdViewController.h"
#import "AppDelegate.h"


@interface MULoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

/** 倒计时 */
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;

@end

@implementation MULoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - viewInit
- (void)viewDidLoad {
    [super viewDidLoad];
  
    //内部层初始化视图
    [self viewInit];
}

- (void)viewInit {
//状态初始化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.getCodeButton addTapTarget:self action:@selector(didGetCodeClicked:)];
    
   
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
}


#pragma mark - Click
#pragma mark 登陆
- (IBAction)didLoginClicked:(id)sender {
    if (!self.agreeButton.selected) {
        [SVProgressHelper dismissWithMsg: @"您未同意新用户注册协议！"];
        return;
    }
    [self.view endEditing:YES];
  
    // 验证码登陆
    if (![MUCustomUtils isValidateTelNumber:self.phoneTextField.text]) {
        [SVProgressHelper dismissWithMsg:@"手机号码格式不正确"];
    }else if(self.codeTextField.text.length == 0) {
        [SVProgressHelper dismissWithMsg:@"请输入验证码"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        NSString *udidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        NSDictionary *pram = @{@"code":self.codeTextField.text,@"sjhm":self.phoneTextField.text,
                               @"yhsjhm":self.phoneTextField.text,
                               @"uuid":udidString,
                               
                               @"scwl":@"wifi",
                               @"sjxh":[NetWork deviceModelName],
                               @"jzxx":@"460-0-0-0",
                               
                               @"yys":@"运营商",
                               @"gps":@"123,46",
                               @"czxtbb":[[UIDevice currentDevice] systemVersion]
                               };
        
        [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/login/zjw/user/logincode") para:pram isShowHUD:YES  isToLogin:NO callBack:^(id  _Nonnull response, BOOL success) {
        
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (success) {
                [self loginSuccess:response[@"data"]];

                NSString * urlString = DetailUrlString(@"/api/login/zjw/user/logincode");
                NSURL * url = [NSURL URLWithString:urlString];
                
                NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
                
                NSMutableArray *temoTemp = [[NSMutableArray alloc]init];
                [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *properties = [[cookie properties] mutableCopy];
                    if ([properties[@"Name"] isEqualToString:@"token"]) {
                        [temoTemp addObject:properties];
                    }
                }];
                if (temoTemp.count) {
                    [[NSUserDefaults standardUserDefaults] setObject:temoTemp forKey:@"Cookie"];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccessNotification object:nil];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
            }else{
//                if (response[@"error"]) {
//                    [weakSelf alertWithMsg:response[@"error"] handler:nil];
//                }else{
//                    [weakSelf alertWithMsg:kFailedTips handler:nil];
//                }
            }
        }];
    }
}

- (void)loginSuccess:(NSDictionary *)dic{
    LoginSession *session = [LoginSession sharedInstance];
    session.token = @"111";//dic[@"token"];
    session.phone = self.phoneTextField.text;
    
    session.yhzt = dic[@"yhzt"];
    session.rzzt = dic[@"rzzt"];
    session.yhbh = dic[@"yhbh"];
    
    session.zjhm = dic[@"zjhm"];
    session.zjlx = dic[@"zjlx"];
    session.sjhm = dic[@"sjhm"];

    [ProUtils removeSession];
    [ProUtils archiveSession:session];
//    [[DBManager shareManager] updatePhone];
    // 更新信息
    //没有登录存本地
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:UserSchoolInfo];
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:UserSchoolInfo];
}

/** 获取验证码 */
- (void)didGetCodeClicked:(id)sender {
  
    if (![MUCustomUtils isValidateTelNumber:self.phoneTextField.text]) {
        [SVProgressHelper dismissWithMsg:@"手机号码格式不正确"];
        return;
    }
    if (self.count > 0) {
        return;
    }
    self.getCodeButton.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *pram = [NSMutableDictionary dictionaryWithObject:self.phoneTextField.text forKey:@"yhsjhm"];
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/login/login/code") para:pram isShowHUD:YES  isToLogin:NO callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            NSLog(@"response  %@",response);
            if ([response[@"code"] integerValue] == 200) {
                [weakSelf startCount];
//                if (response[@"data"] != nil && [response[@"data"] isKindOfClass:[NSString class]]) {//假数据
//                    self.codeTextField.text = response[@"data"];
//                }
            }else{
                self.getCodeButton.userInteractionEnabled = YES;
//                [weakSelf alertWithMsg:response[@"error"] handler:nil];
            }
        }else{
            self.getCodeButton.userInteractionEnabled = YES;

        }
    }];
}

- (void)startCount {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didOneSecReached:) userInfo:nil repeats:YES];
    self.count = 60;
    
    UILabel *tempLabel;
    tempLabel = self.getCodeButton;
    tempLabel.text = @"60秒后重新获取";
}
- (void)didOneSecReached:(id)sender {
    UILabel *tempLabel;
    tempLabel = self.getCodeButton;
    
    if (self.count > 0) {
        self.count--;
        NSString *countStr = [NSString stringWithFormat:@"%ld秒后重新获取",self.count];
        tempLabel.text = countStr;
        if (self.count == 0) {
            self.getCodeButton.userInteractionEnabled = YES;
            tempLabel.text = @"获取验证码";
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** 返回 */
- (IBAction)didReturnClicked:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertWithMsg:(NSString *)msg handler:(void (^)())handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler != nil) {
            handler();
        }
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)keyboardChange:(NSNotification *)note{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyHeight =  [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    self.view.frame = CGRectMake(0, -keyHeight/5, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (IBAction)agreeButtonClick:(id)sender {
    self.agreeButton.selected = !self.agreeButton.selected;
}
- (IBAction)agreePageClick:(id)sender {
     [self.navigationController pushViewController:[MURootViewController new] animated:YES];
}


//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//
//    if (textField == self.phoneTextField) {
//        self.codePhoneTipLabel.hidden = NO;
//        self.codePassWordTipLabel.hidden = YES;
//        self.codePhoneTipLine.backgroundColor = kMainColor;
//        self.codePassWordTipLine.backgroundColor = kLineColorDE;
//
//    }else if (textField == self.codeTextField) {
//        self.codePhoneTipLabel.hidden = YES;
//        self.codePassWordTipLabel.hidden = NO;
//        self.codePhoneTipLine.backgroundColor = kLineColorDE;
//        self.codePassWordTipLine.backgroundColor = kMainColor;
//    }
//   return  YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}

@end
