//
//  MyHouseCodeViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseCodeViewController.h"
#import "QiCodeManager.h"
#import "UIView+add.h"
#import "MyHousePaySuccessViewController.h"

@interface MyHouseCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageViewTop;


@property (weak, nonatomic) IBOutlet UIImageView *codeImageMid;
@property (weak, nonatomic) IBOutlet UIView *codeBackGround;
@property (weak, nonatomic) IBOutlet UILabel *tipReturnLabel;
@property (weak, nonatomic) IBOutlet UIButton *refeashButton;


@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MyHouseCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.codeBackGround setCornerRadius:5 withShadow:YES withOpacity:5];
    [self.codeBackGround setCornerRadius:4 withShadow:YES withOpacity:10 withAlpha:0.1 withCGSize:CGSizeMake(1, 4)];
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    
    [self startTimer];
}

- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(didOneSecReached:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)didOneSecReached:(NSTimer *)sender {
    static int i = 0;
    NSLog(@"NSTimer: %d",i);
    i++;
    if (i>30) {
        if (self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    if (_pramDic) {
        [self refeashClick:nil];
    }else{
        self.tipReturnLabel.hidden = NO;
    }
}

- (IBAction)refeashClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/contract/paymentinfo") para:_pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            [weakSelf loadingPageSuccess];
            
            NSDictionary *temp = response[@"data"];
            if ([temp[@"paystatus"] integerValue] == 1) {
                MyHousePaySuccessViewController *vc = [MyHousePaySuccessViewController new];
                vc.dataDic = temp;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                if (weakSelf.timer != nil) {
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                }

            }else if([temp[@"paystatus"] integerValue] == 1
//                     &&[weakSelf.pramDic[@"paytype"] isEqualToString:@"房款"]
                     ){
                if ([temp[@"zfje"] integerValue]>0) {
                    weakSelf.refeashButton.hidden = NO;
                    NSString *strStip = [NSString stringWithFormat:@"已缴金额：%@\t需缴金额：%@\t",temp[@"zfje"],temp[@"hjyjje"]];
                    //                        [self alertWithMsg:strStip handler:nil];
                    self.tipReturnLabel.hidden = NO;
                    self.tipReturnLabel.textColor = kUIColorFromRGB(0xFF0000);
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strStip];
                    NSRange range2 = [strStip rangeOfString:@"已缴金额："];
                    NSRange range3 = [strStip rangeOfString:@"需缴金额："];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x797878) range:range2];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0x797878) range:range3];
                    [self.tipReturnLabel setAttributedText:attributedString];
                }
            }
        
        }else{
            [weakSelf loadingPageError];
        }
    }];
}


- (void)setCodeStr:(NSString *)codeStr{
    _codeStr = codeStr;
    _codeLabel.text = _codeStr;
    __block NSString *text = _codeStr;
    __block CGSize size = _codeImageMid.bounds.size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *code = text;
        UIImage *codeImage = [QiCodeManager generateQRCode:code size:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImageMid.image = codeImage;
        });
    });
    
    __block CGSize size2 = _codeImageViewTop.bounds.size;//条码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *code = text;
        UIImage *codeImage = [QiCodeManager generateCode128:code size:size2];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImageViewTop.image = codeImage;
        });
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (IBAction)navBackClick:(id)sender {
    [self callBackClick];
}


@end
