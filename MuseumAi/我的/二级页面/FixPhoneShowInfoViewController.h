//
//  FixPhoneShowInfoViewController.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/23.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MURootViewController.h"
//#import "PureCamera.h"
#import "JYBDIDCardVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FixPhoneShowInfoViewController : MURootViewController

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *sexTextField;
@property (weak, nonatomic) IBOutlet UITextField *nationTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;


@property (strong, nonatomic) JYBDCardIDInfo *info;
@property (strong, nonatomic) UIImage *infoImage;
@end

NS_ASSUME_NONNULL_END
