//
//  MyCenterViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterViewController.h"
#import "MyCenterTableViewCell.h"
#import "AppendChooseViewController.h"
#import "MyCenterLoginOutTableViewCell.h"
#import "HousesListViewController.h"
#import "QuesttionListViewController.h"
#import "ResultQualityViewController.h"
#import "RealFirstTipViewController.h"
#import "MyCenterAboutViewController.h"
#import "MyCenterSettingViewController.h"
#import "RealFirstTipViewController.h"
#import "MyCenterChangePhoneViewController.h"

@interface MyCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerItemWidth;

@property (strong, nonatomic) NSArray *dataArray;


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *realBoard;
@property (weak, nonatomic) IBOutlet UILabel *realLabel;
@property (weak, nonatomic) IBOutlet UILabel *identityCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityStatueLabel;
@property (weak, nonatomic) IBOutlet UIButton *goIntoReal;

@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;

@property (strong, nonatomic) RealFinishTipView1 *tipView1;
@end

@implementation MyCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self customReloadData];
    [self dataRelaod];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerItemWidth.constant = 168*CustomScreenFit;
    self.view.backgroundColor = kListBgColor;
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"},
                   @{@"title":@"用户设置",@"content":@"myCenter_setting"},
                   @{@"title":@"关于悦居星城",@"content":@"myCenter_about"}
                   ];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCenterTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyCenterTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCenterLoginOutTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyCenterLoginOutTableViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
   
}

- (void)customReloadData{
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/myshow") para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            NSDictionary *dic = response[@"data"];
            [LoginSession sharedInstance].sjhm = [dic objectForKey:@"zcyh"][@"sjhm"];//
            [LoginSession sharedInstance].rzzt = [dic objectForKey:@"zcyh"][@"rzzt"];//
            [LoginSession sharedInstance].grrzzt = [dic objectForKey:@"jtcy"][@"rzzt"];
            weakSelf.identityCountLabel.text = [NSString stringWithFormat:@"%@",dic[@"renchou"]];//我的认筹
            [weakSelf dataRelaod];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)dataRelaod{
    self.phoneLabel.text = [LoginSession sharedInstance].sjhm;
    if (!self.phoneLabel.text.length) {
        self.phoneLabel.text = [LoginSession sharedInstance].phone;
    }
    
    if (![Utility is_empty:[LoginSession sharedInstance].rzzt]) {
        NSInteger rzzt = [[LoginSession sharedInstance].rzzt integerValue];
        if ( rzzt== 2) {
            [self.goIntoReal setTitle:@">" forState:UIControlStateNormal];
            self.realLabel.text = @"已实名认证";
        }else if (rzzt == 3) {
            [self.goIntoReal setTitle:@">" forState:UIControlStateNormal];
            self.realLabel.text = @"实名认证未通过";
        }else if (rzzt == 1 || rzzt == 0) {
            [self.goIntoReal setTitle:@">" forState:UIControlStateNormal];
            self.realLabel.text = @"实名认证待审核";
        }else{
            [self.goIntoReal setTitle:@"去认证   >" forState:UIControlStateNormal];
            self.realLabel.text = @"未实名认证";
        }
    }else{
        [self.goIntoReal setTitle:@"去认证   >" forState:UIControlStateNormal];
        self.realLabel.text = @"未实名认证";
    }
    
    self.qualityStatueLabel.text = @"未提交";//已通过  待审核
    if (![Utility is_empty:[LoginSession sharedInstance].grrzzt]) {
        
        NSInteger grrzzt = [[LoginSession sharedInstance].grrzzt integerValue];
        if (grrzzt == 2) {
            self.qualityStatueLabel.text = @"未通过";//已通过  待审核
        }else if (grrzzt == 0) {
            self.qualityStatueLabel.text = @"待审核";//已通过  待审核
        }else if (grrzzt == 1) {
            self.qualityStatueLabel.text = @"已通过";//已通过  待审核
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1){
        return 1;
    }
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MyCenterLoginOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterLoginOutTableViewCell" forIndexPath:indexPath];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    MyCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCenterTableViewCell" forIndexPath:indexPath];
    
    cell.logoImageView.image = [UIImage imageNamed:_dataArray[indexPath.row][@"content"]];
    cell.titleLabel.text = _dataArray[indexPath.row][@"title"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 77.0;
    }
    return 55.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self loginoutShowTipView];
        return;
    }
    switch (indexPath.row) {
        case 0://浏览记录
        {
            HousesListViewController *vc = [HousesListViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"浏览历史";
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 1://资料修改
        {
            [self changeShowTipView];
        }break;
        case 2://常见问题
        {
            QuesttionListViewController *vc = [QuesttionListViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 3://用户设置
        {
            MyCenterSettingViewController *vc = [MyCenterSettingViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
//            [self.navigationController pushViewController:[AppendChooseViewController new] animated:YES];
        }break;
        case 4://关于
        {
            MyCenterAboutViewController *vc = [MyCenterAboutViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
            
        default:
            break;
    }
}

- (IBAction)identityClick:(id)sender {//我的认筹
    HousesListViewController *vc = [HousesListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"我的认筹";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)qualityClick:(id)sender {//购房资格
    
    if (![Utility is_empty:[LoginSession sharedInstance].grrzzt]) {
        if ([[LoginSession sharedInstance].grrzzt integerValue] == 0||[[LoginSession sharedInstance].grrzzt integerValue] == 1) {
            ResultQualityViewController *vc = [ResultQualityViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.isReal = NO;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    RealFirstTipViewController *vc = [RealFirstTipViewController new];
    vc.title = @"购房资格审查说明";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)realClick:(id)sender {//[[LoginSession sharedInstance].rzzt integerValue]>0
    if ([LoginSession sharedInstance].rzzt) {
        
        ResultQualityViewController *vc = [ResultQualityViewController new];
        vc.title = @"实名认证";
        vc.hidesBottomBarWhenPushed = YES;
        vc.isReal = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    RealFirstTipViewController *vc = [RealFirstTipViewController new];
    vc.title = @"关于实名认证";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeShowTipView{
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _tipView1.contentTitleLabel.text = @"提交修改将撤销本次购房资格审查结果\n是否继续？";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_tipView1.contentTitleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5; // 调整行间距
    NSRange range = NSMakeRange(0, [_tipView1.contentTitleLabel.text length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    NSRange range2 = [_tipView1.contentTitleLabel.text rangeOfString:@"是否继续？"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    
    [_tipView1.contentTitleLabel setAttributedText:attributedString];
    _tipView1.contentTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self startCount];
    _tipView1.sureButton.userInteractionEnabled = NO;
    [_tipView1.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)startCount {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didOneSecReached:) userInfo:nil repeats:YES];
    self.count = 3;
    
    [_tipView1.sureButton setTitle:@"3s后可继续" forState:UIControlStateNormal];
    _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
}
- (void)didOneSecReached:(id)sender {
    
    if (self.count > 0) {
        self.count--;
        NSString *countStr = [NSString stringWithFormat:@"%lds后可继续",self.count];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateNormal];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateSelected];
        _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
        if (self.count == 0) {
            
            _tipView1.sureButton.userInteractionEnabled = YES;
            [_tipView1.sureButton setTitle:@"确认继续" forState:UIControlStateNormal];
            [_tipView1.sureButton setTitle:@"确认继续" forState:UIControlStateSelected];
            _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xC0905D);
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)sureButtonClick{
    
    
    
    if (![Utility is_empty:[LoginSession sharedInstance].grrzzt]) {
        if ([[LoginSession sharedInstance].grrzzt integerValue] == 0) {
            [SVProgressHelper dismissWithMsg:@"购房资格审核过程中，不能修改信息"];
            return;
        }
        if ([[LoginSession sharedInstance].grrzzt integerValue] == 2||[[LoginSession sharedInstance].grrzzt integerValue] == 1) {
            RealFirstTipViewController *vc = [RealFirstTipViewController new];
            vc.title = @"购房资格审查说明";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    [SVProgressHelper dismissWithMsg:@"没找到有效购房资格信息，请先进行购房资格申请"];
}

- (void)loginoutShowTipView{
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _tipView1.contentTitleLabel.text = @"是否退出当前登录状态？";
    [_tipView1.sureButton addTarget:self action:@selector(loginoutFinishClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginoutFinishClick{
    //退出登录接口 清除个人信息 coocle
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Cookie"];
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/login/zjw/user/logout") para:nil isShowHUD:YES  isToLogin:NO callBack:^(id  _Nonnull response, BOOL success) {
        if (success) {
//            [weakSelf.contentCollectionView reloadData];
        }else{
//            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
    
    MULoginViewController *loginController = [[MULoginViewController alloc] init];
    [[ProUtils getCurrentVC] presentViewController:loginController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)] && indexPath.section==0) {
        //        if (tableView == self.tableView) {
        CGFloat cornerRadius = 5.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor=[UIColor whiteColor].CGColor;
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
    //    }
}


- (IBAction)changePhone:(id)sender {
    
    
    MyCenterChangePhoneViewController *vc = [MyCenterChangePhoneViewController new];
    vc.title = @"更换手机号";
    vc.hidesBottomBarWhenPushed = YES;
//    vc.isReal = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
