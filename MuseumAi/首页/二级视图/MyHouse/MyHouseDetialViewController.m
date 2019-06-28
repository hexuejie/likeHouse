//
//  MyHouseDetialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseDetialViewController.h"
#import "MyHouseDetialOneCell.h"
#import "MyHouseDetialTwoCell.h"
#import "MuHouseDetialHeader.h"
#import "MyHouseTaxViewController.h"
#import "MyHouseCodeViewController.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"

@interface MyHouseDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *codeImageButton;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NSDictionary *dataDic;
@end

@implementation MyHouseDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"购房信息";
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    _dataArray = @[@[@{@"title":@"房屋坐落："},
                   @{@"title":@"栋号：",@"title2":@"室号："},
                   @{@"title":@"建筑面积：",@"title2":@"套内面积："},
                   @{@"title":@"购房人："},
                   @{@"title":@"共有人："},
                   @{@"title":@"开发公司："},
                     @{@"title":@"物业："}],
                   
                   @[@{@"title":@"签订时间："},
                     @{@"title":@"备案状态："},
                     @{@"title":@"办证状态："}],
                   
                   @[@{@"title":@"总房款：",@"title2":@"首付："}
                   ,@{@"title":@"已缴纳：",@"title2":@"贷款："}],
                   @[@{@"title":@"契税应缴：",@"title2":@"契税实缴："}
                     ,@{@"title":@"印花税应缴：",@"title2":@"印花税实缴："}],
                   @[@{@"title":@"维修资金应缴：",@"title2":@"维修资金实缴："}
                    ,@{@"title":@"缴交标准："}],
                   ];
    [self initView];
    
    //    [self addNoneDataTipView];
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf reloadData];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >=2 &&indexPath.row == 0) {//小标题
        MyHouseDetialTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseDetialTwoCell" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 2:cell.headerTitle.text = @"房款缴纳";
                break;
            case 3:cell.headerTitle.text = @"税额缴纳";
                break;
            case 4:cell.headerTitle.text = @"维修资金缴纳";
                break;
            default:
                break;
        }
        cell.headerButton.tag = indexPath.section;
        [cell.headerButton addTarget:self action:@selector(headerButtonToFix:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSDictionary *tempDic = _dataArray[indexPath.section][indexPath.row];
    MyHouseDetialOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseDetialOneCell" forIndexPath:indexPath];
    cell.secondTag = NO;
    cell.titleLabel1.text = tempDic[@"title"];
    if (tempDic[@"title2"]) {//有两个
        cell.secondTag = YES;
        cell.titleLabel2.text = tempDic[@"title2"];
    }
    NSString *content1;
    NSString *content2;
    switch (indexPath.section) {
        case 0:{
            NSDictionary *contentDic = self.dataDic[@"houseVO"];
            if (indexPath.row == 0) {
                content1 = contentDic[@"fwzl"];
            }else if (indexPath.row == 1) {
                content1 = contentDic[@"dh"];
                content2 = contentDic[@"sh"];
            }else if (indexPath.row == 2) {
                content1 = contentDic[@"jzmj"];
                content2 = contentDic[@"tnmj"];
            }else if (indexPath.row == 3) {
                content1 = contentDic[@"gfr"];
            }else if (indexPath.row == 4) {
                content1 = contentDic[@"gyr"];
            }else if (indexPath.row == 5) {
                content1 = contentDic[@"kfgsmc"];
            }else if (indexPath.row == 6) {
                content1 = contentDic[@"wygsmc"];
            }
        }break;
        case 1:{
            NSDictionary *contentDic = self.dataDic[@"paperVO"];
            if (indexPath.row == 0) {
                content1 = contentDic[@"htqdrq"];
            }else if (indexPath.row == 1) {
                content1 = contentDic[@"bazt"];
            }else if (indexPath.row == 2) {
                content1 = contentDic[@"bzzt"];
            }//url
        }break;
        case 2:{
            NSDictionary *contentDic = self.dataDic[@"paymentVO"][@"housePayment"];
            if (indexPath.row == 0) {
                content1 = contentDic[@"zje"];
                content2 = contentDic[@"sfje"];
            }else if (indexPath.row == 1) {
                content1 = contentDic[@"yjje"];
                content2 = contentDic[@"dkje"];
            }
        }break;
        case 3:{
            NSDictionary *contentDic = self.dataDic[@"paymentVO"][@"taxPayment"];
            if (indexPath.row == 0) {
                content1 = contentDic[@"qsyjje"];
                content2 = contentDic[@"qssjje"];
            }else if (indexPath.row == 1) {
                content1 = contentDic[@"yhsyjje"];
                content2 = contentDic[@"yhssjje"];
            }
        }break;
        case 4:{
            NSDictionary *contentDic = self.dataDic[@"paymentVO"][@"fundsPayment"];
            if (indexPath.row == 0) {
                content1 = contentDic[@"yjje"];
                content2 = contentDic[@"sjje"];
            }else if (indexPath.row == 1) {
                content1 = contentDic[@"jjbz"];
            }
        }break;
        default:
            break;
    }
    cell.contentLabel1.text = [NSString stringWithFormat:@"%@",content1];
    cell.contentLabel2.text = [NSString stringWithFormat:@"%@",content2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//paperVO =     {
//    htqdrq = "2002/12/23",
//    htqdsj = "12:50:25",
//    bazt = "申请备案，尚未进窗",
//    urltype = 0,
//    htbh = "20021255605",
//    qybh = "430100",
//    qymc = "长沙市",
//},
- (void)headerButtonToFix:(UIButton *)button{
    switch (button.tag) {
        case 2:
        {
            MyHouseTaxViewController *vc = [MyHouseTaxViewController new];
            vc.title = @"房款缴纳";
            vc.dataDic = self.dataDic[@"paymentVO"][@"housePayment"];
            vc.htbh = self.dataDic[@"paperVO"][@"htbh"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            MyHouseTaxViewController *vc = [MyHouseTaxViewController new];
            vc.title = @"税额缴纳";
            vc.dataDic = self.dataDic[@"paymentVO"][@"taxPayment"];
            vc.htbh = self.dataDic[@"paperVO"][@"htbh"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            MyHouseTaxViewController *vc = [MyHouseTaxViewController new];
            vc.title = @"维修资金缴纳";
            vc.dataDic = self.dataDic[@"paymentVO"][@"fundsPayment"];
            vc.htbh = self.dataDic[@"paperVO"][@"htbh"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section <=2) {
        if (section == 0) {
            return 60;
        }
        return 54.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section <=2) {
        MuHouseDetialHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MuHouseDetialHeader"];
        header.contentView.backgroundColor = [UIColor whiteColor];
        header.bottomLine.hidden = NO;
        if (section == 2) {
            header.bottomLine.hidden = YES;
        }
        if (section != 1) {
            header.headerButton.hidden = YES;
        }else{
            header.headerButton.hidden = NO;
        }
        switch (section) {
            case 0:header.headerTitle.text = @"房屋信息";
                break;
            case 1:header.headerTitle.text = @"合同信息";
                break;
            case 2:header.headerTitle.text = @"缴款信息";
                break;
            default:
                break;
        }
        return header;
    }
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0||section == 1) {
        return 10.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)initView{
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.codeImageButton = [[UIButton alloc]init];
    [self.codeImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeImageButton addTarget:self action:@selector(pushToMyHouseCodeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.codeImageButton setTitle:@"缴款二维码" forState:UIControlStateNormal];
    self.codeImageButton .backgroundColor =  kUIColorFromRGB(0xC0905D);
    self.codeImageButton.titleLabel.font = kSysFont(17.0);
    self.codeImageButton.layer.cornerRadius = 2.0;
    self.codeImageButton.clipsToBounds = YES;
    [self.view addSubview:self.codeImageButton];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-0);
        make.leading.equalTo(self.view).offset(0);
        make.trailing.equalTo(self.view).offset(-0);
        make.height.mas_equalTo(70);
    }];
    [self.codeImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-23);
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseDetialOneCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseDetialOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseDetialTwoCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseDetialTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MuHouseDetialHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"MuHouseDetialHeader"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.codeImageButton.mas_top).offset(-3);
        make.leading.trailing.top.equalTo(self.view).offset(0);
    }];
}

- (void)pushToMyHouseCodeViewController{
    MyHouseCodeViewController *vc = [MyHouseCodeViewController new];
    vc.title = @"税额缴纳";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        vc.codeStr = [NSString stringWithFormat:@"%@",self.dataDic[@"paymentVO"][@"mainQRCode"]];
    });
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    self.dataArray = [NSMutableArray new];
    NSDictionary *pram = [self.model mj_keyValues];
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/contract/detail") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {

            weakSelf.dataDic = response[@"data"];
            [weakSelf.tableView reloadData];
            if (weakSelf.dataDic.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
@end
