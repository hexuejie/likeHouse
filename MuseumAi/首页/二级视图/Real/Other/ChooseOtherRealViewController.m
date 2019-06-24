//
//  ChooseOtherRealViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/29.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseOtherRealViewController.h"
#import "UIView+add.h"
#import "RealFinishTipView1.h"
#import "RealChooseHKViewController.h"
#import "RealChooseForeignViewController.h"
#import "RealFirstChooseViewController.h"
#import "ChooseAddMateshipViewController.h"
#import "AddChildrenViewController.h"

@interface ChooseOtherRealViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView0;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;

@end

@implementation ChooseOtherRealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择身份";
    
    [self.bgView0 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView1 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView2 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView3 setCornerRadius:5 withShadow:YES withOpacity:10];
}

- (IBAction)chooseOtherClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 10:
            {
                RealFinishTipView1 * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
                _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
                _tipView1.sureType = 2;
            }
            break;
        case 11:
        {
            [self.navigationController pushViewController:[RealChooseHKViewController new] animated:YES];
        }
            break;
        case 12:
        {
            [self.navigationController pushViewController:[RealChooseForeignViewController new] animated:YES];
        }
            break;
        case 9:
        {
            if ([LoginSession sharedInstance].pageType == 1) {
                 [self.navigationController pushViewController:[ChooseAddMateshipViewController new] animated:YES];
            }else if ([LoginSession sharedInstance].pageType == 2) {
                [self.navigationController pushViewController:[AddChildrenViewController new] animated:YES];
            }else{
                [self.navigationController pushViewController:[RealFirstChooseViewController new] animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}


@end
