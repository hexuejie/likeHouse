//
//  ResultQualityResultVC.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/17.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ResultQualityResultVC.h"
#import "ResultQualityViewController.h"

@interface ResultQualityResultVC ()

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) NSDictionary *rzbzStr;

@end

@implementation ResultQualityResultVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [LoginSession sharedInstance].isNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [LoginSession sharedInstance].isNavigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)lookOutClick:(id)sender {
    
    ResultQualityViewController *vc = [ResultQualityViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isReal = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)reloadData{
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/allmessage/new") para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            NSDictionary *allDic = response[@"data"];
            
            weakSelf.dataDic = allDic[@"zgsc"];
            //grxx =     {
            //    jtcy =     {
            //        rzbz
            weakSelf.rzbzStr = allDic[@"grxx"][@"jtcy"][@"rzbz"];
            if (weakSelf.dataDic.count == 0) {
                [weakSelf addNoneDataTipView];
            }else{
                [weakSelf reloadView];
            }
        }else{
        }
    }];
}

- (void)reloadView{
    NSString *strsresult = @"result_result1";
    if ([[LoginSession sharedInstance].grrzzt integerValue] == 0) {
        strsresult = @"result_result1";
    }else if ([[LoginSession sharedInstance].grrzzt integerValue] == 1) {
        strsresult = @"result_result3";
    }else if ([[LoginSession sharedInstance].grrzzt integerValue] == 2) {
        strsresult = @"result_result2";
    }
    self.mainImageView.image = [UIImage imageNamed:strsresult];
    
    if ([[LoginSession sharedInstance].grrzzt integerValue] == 0) {
        self.titleLabel1.text = @"您的购房资格申请提交成功！";
        self.contentLabel.text = @"预计3-5个工作日内审核完毕，请耐心等候";
        
        self.tipLabel1.text = @"";
        self.titleLabel2.text = @"";
        self.tipLabel2.text = @"";
        return;
    }
    
    self.titleLabel1.text = [NSString stringWithFormat:@"您的审核%@",self.dataDic[@"hzbz"]];
    self.contentLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"hzjl"]];

    NSString *strsfgx = @"非刚需";
    if ([self.dataDic[@"sfgx"] isEqualToString:@"是"]) {
        strsfgx = @"刚需";
    }
    self.tipLabel1.text = [NSString stringWithFormat:@"基本信息：%@，%@，家庭住房%@套",strsfgx,self.dataDic[@"hjfq"],self.dataDic[@"jtzfts"]];

    self.titleLabel2.text = [NSString stringWithFormat:@"认证%@：",self.dataDic[@"hzbz"]];
    if (self.rzbzStr) {
        self.tipLabel2.text = [NSString stringWithFormat:@"%@",self.rzbzStr];
    }
}


//zgsc =     {
//    drsj = "16:14:01",
//    dcry = "SA",
//    sfgx = "是",//是 刚需 否 非刚需
//    hzrq = "2019-07-17",
//    jtzfts = 0,  家庭住房0套
//    drrq = "2019-07-17",
//    sbsj = "16:00:30",
//    dcsj = "16:14:01",
//    gxjl = "刚需，本市无房个人",
//    hzry = "SA",
//    gxlx = "本市无房个人",
//    drry = "SA",
//    hjfq = "本市",  ？//
//    sbrq = "2019-07-17",
//    dcrq = "2019-07-17",
//    jtlh = "J0245629",
//    hzsj = "16:14:01",
//    hzbz = "通过",
//},

//grxx =     {
//    jtcy =     {
//        rzbz

- (IBAction)backClick:(id)sender {
    [self callBackClick];
}

@end
