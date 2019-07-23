//
//  FixPhoneShowInfoViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/23.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "FixPhoneShowInfoViewController.h"
#import "MyCenterChangePhoneViewController.h"

@interface FixPhoneShowInfoViewController ()

@end

@implementation FixPhoneShowInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.coverImageView.image = self.infoImage;
    self.nameTextField.text = _info.name;
    self.sexTextField.text = _info.gender;
    self.nationTextField.text = _info.nation;
    self.birthdayTextField.text = [_info.num substringWithRange:NSMakeRange(6, 8)];
    self.addressTextField.text = _info.address;
    self.numberTextField.text = _info.num;
}

- (IBAction)nextStepClick:(id)sender {
    if (![LoginSession sharedInstance].rzzt) {
        [SVProgressHelper dismissWithMsg: @"必须实名认证后才能修改手机号！"];
        return;
    }
    MyCenterChangePhoneViewController *vc = [MyCenterChangePhoneViewController new];
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
