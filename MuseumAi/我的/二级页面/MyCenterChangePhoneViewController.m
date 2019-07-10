//
//  MyCenterChangePhoneViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterChangePhoneViewController.h"

@interface MyCenterChangePhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *getCodeButton;

/** 倒计时 */
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;

@end

@implementation MyCenterChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.getCodeButton addTapTarget:self action:@selector(didGetCodeClicked:)];
    
    self.phoneTextField.delegate = self;
    self.codeTextField.delegate = self;
}

/** 获取验证码 */
- (void)didGetCodeClicked:(id)sender {
    
    if (![MUCustomUtils isValidateTelNumber:self.phoneTextField.text]) {
        [self alertWithMsg:@"手机号码格式不正确" handler:nil];
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
                
            }else{
                self.getCodeButton.userInteractionEnabled = YES;
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


#pragma mark - Click
#pragma mark 登陆
- (IBAction)didLoginClicked:(id)sender {
 
    [self.view endEditing:YES];
    
    // 验证码登陆
    if (![MUCustomUtils isValidateTelNumber:self.phoneTextField.text]) {
        [self alertWithMsg:@"手机号码格式不正确" handler:nil];
    }else if(self.codeTextField.text.length == 0) {
        [self alertWithMsg:@"请输入验证码" handler:nil];
    }else {
        [self alertWithMsg:@"请求方法不存在" handler:nil];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        __weak typeof(self) weakSelf = self;
//        NSString *udidString = [UIDevice currentDevice].identifierForVendor.UUIDString;
//        NSDictionary *pram = @{@"code":self.codeTextField.text,@"sjhm":self.phoneTextField.text,
//                               @"yhsjhm":self.phoneTextField.text,
//                               @"uuid":udidString,
//
//                               @"scwl":@"wifi",
//                               @"sjxh":@"Meizu16",
//                               @"jzxx":@"460-0-0-0",
//
//                               @"yys":@"运营商",
//                               @"gps":@"123,46",
//                               @"czxtbb":@"8.1.0"
//                               };
//
//        [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/login/zjw/user/logincode") para:pram isShowHUD:YES  isToLogin:NO callBack:^(id  _Nonnull response, BOOL success) {
//
//            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//            if (success) {
////                [self loginSuccess:response[@"data"]];
//
//                NSString * urlString = DetailUrlString(@"/api/login/zjw/user/logincode");
//                NSURL * url = [NSURL URLWithString:urlString];
//                NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//                NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
//
//                NSMutableArray *temoTemp = [[NSMutableArray alloc]init];
//                [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSMutableDictionary *properties = [[cookie properties] mutableCopy];
//                    if ([properties[@"Name"] isEqualToString:@"token"]) {
//                        [temoTemp addObject:properties];
//                    }
//                }];
//                if (temoTemp.count) {
//                    [[NSUserDefaults standardUserDefaults] setObject:temoTemp forKey:@"Cookie"];
//                }
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccessNotification object:nil];
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//
//            }else{
//
//            }
//        }];
    }
}
@end
