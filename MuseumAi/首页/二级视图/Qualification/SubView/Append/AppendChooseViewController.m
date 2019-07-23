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


@property (strong, nonatomic) NSDictionary *dataDic;

@property (assign, nonatomic) BOOL tsrc;
@property (assign, nonatomic) BOOL zsjt;
@property (assign, nonatomic) BOOL szssb;

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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customReload];
}

- (void)customReload{
    
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/pdspecial") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            weakSelf.dataDic = response[@"data"];
            if (![Utility is_empty:weakSelf.dataDic[@"tsrc"]]) {
                weakSelf.tsrc = [weakSelf.dataDic[@"tsrc"] boolValue];
            }
            if (![Utility is_empty:weakSelf.dataDic[@"zsjt"]]) {
                weakSelf.zsjt = [weakSelf.dataDic[@"zsjt"] boolValue];
            }
            if (![Utility is_empty:weakSelf.dataDic[@"szssb"]]) {
                weakSelf.szssb = [weakSelf.dataDic[@"szssb"] boolValue];
            }
            weakSelf.tagLabel1.text = @"无";
            weakSelf.tagLabel2.text = @"无";
            weakSelf.tagLabel3.text = @"无";
            if (weakSelf.tsrc) {
                weakSelf.tagLabel1.text = @"已添加";
            }
            if (weakSelf.zsjt) {
                weakSelf.tagLabel2.text = @"已添加";
            }
            if (weakSelf.szssb) {
                weakSelf.tagLabel3.text = @"已添加";
            }
//            [weakSelf.tableView reloadData];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}
@end
