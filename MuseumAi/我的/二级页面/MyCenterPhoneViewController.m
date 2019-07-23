//
//  MyCenterPhoneViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/23.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterPhoneViewController.h"
#import "PureCamera.h"
#import "JYBDIDCardVC.h"
#import "FixPhoneShowInfoViewController.h"

@interface MyCenterPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation MyCenterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.phoneTextField.text = [LoginSession sharedInstance].phone;
    self.view.backgroundColor = kListBgColor;
}

- (IBAction)didLoginClicked:(id)sender {
    
    __weak __typeof__(self) weakSelf = self;
    
    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.isBehinded = NO;
    
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {

        FixPhoneShowInfoViewController *vc = [FixPhoneShowInfoViewController new];
        vc.title = weakSelf.title;
        vc.info = info;
        vc.infoImage = image;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self presentViewController:AVCaptureVC animated:YES completion:nil];
}
@end

