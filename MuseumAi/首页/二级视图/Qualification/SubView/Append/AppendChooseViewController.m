//
//  AppendChooseViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AppendChooseViewController.h"
#import "UIView+add.h"
#import "RealFinishTipView1.h"
#import "AppendOneTipViewController.h"
#import "AppendThreeViewController.h"
#import "AppendTwoViewController.h"
#import "ChooseQualificationTypeViewController.h"

@interface AppendChooseViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;


@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel3;

@end

@implementation AppendChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"附加信息";
    
    [self.bgView1 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView2 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView3 setCornerRadius:5 withShadow:YES withOpacity:10];
}

- (IBAction)chooseOtherClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10:
        {
            [self.navigationController pushViewController:[AppendOneTipViewController new] animated:YES];
        }
            break;
        case 11:
        {
            [self.navigationController pushViewController:[AppendTwoViewController new] animated:YES];
        }
            break;
        case 12:
        {
            [self.navigationController pushViewController:[AppendThreeViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (IBAction)saveButtonClick:(id)sender {
    [self callBackClick];
//    if (self.oneTextField.text.length>0&&
//        self.twoTextField.text.length>0&&
//        self.threeTextField.text.length>0&&
//        self.addImageView.image
//        ) {
//
//        [SVProgressHelper dismissWithMsg:@"保存成功 刷新数据！"];
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[ChooseQualificationTypeViewController class]]) {
//                ChooseQualificationTypeViewController *A =(ChooseQualificationTypeViewController *)controller;
//                [self.navigationController popToViewController:A animated:YES];
//            }
//        }
//
//    }else{
//        [SVProgressHelper dismissWithMsg:@"请完善申请人信息!"];
//    }
}


@end
