//
//  MyHouseTaxViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseTaxViewController.h"
#import "MyHouseTaxContentCell.h"
#import "MyHouseTaxContentBottomCell.h"
#import "MyHouseTaxHeaderCell.h"
#import "MuHouseDetialHeader.h"
#import "MyHouseCodeViewController.h"
#import "MyHouseBottomPapaer.h"

@interface MyHouseTaxViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *headerArray;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NSMutableArray *contentArray;
@end

@implementation MyHouseTaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    
    [self initView];
}

- (void)customAddContentWith:(NSArray *)keys{
    _contentArray = [NSMutableArray new];
    for (NSString *strKey in keys) {
        [_contentArray addObject:[NSString stringWithFormat:@"%@",_dataDic[strKey]]];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    if ([self.title isEqualToString:@"房款缴纳"]) {
        _dataArray = @[@[@"项目名称",@"栋号",@"室号",@"坐落描述",
                         @"购房人",@"证件类型",@"证件号码",@"监管银行",
                         @"监管账号",@"备注",@"应缴金额（元）",@"应缴金额（大写）"
                           ]];
        [self customAddContentWith:@[@"xmmc",@"dh",@"sh",@"zlms"
                                     ,@"gfr",@"gfrzjlx",@"gfrzjhm",@"jgyhmc"
                                     ,@"jgyhzh",@"bz",@"yjje",@"yjjedx"]];
        _headerArray = @[@" "];
        
    }else if ([self.title isEqualToString:@"税额缴纳"]) { // jkqx
        _dataArray = @[@[@"纳税人识别号",@"纳税人名称",@"税款限缴日期",@"自缴ID",@"购房人名称",@"证件号码",@"房屋用途",@"建筑面积（㎡）",@"合同签订日期",@"购房人家庭已有住房"],
                       @[@"征收项目名称",@"计税金额（元）",@"税率（%）",@"应缴税额（元）"],
                       @[@"征收项目名称",@"计税金额（元）",@"税率（%）",@"应缴税额（元）",@"合计（小写）",@"合计（大写）"]
                       ];
        [self customAddContentWith:@[@"nsrsbh",@"nsrxm",@"jkqx",@"zjid",@"gfr",@"gfrzjhm",@"fwyt",@"jzmj"
                                     ,@"htqdrq",@"jtyyzfts"//前十
                                     ,@"qszsmc",@"qsjsje",@"qsjssl",@"qsyjje"
                                     ,@"yhszsmc",@"yhsjsje",@"yhsjssl",@"yhsyjje" ,@"hjyjje",@"hjyjjedx"]];
        
        //纳税人识别号nsrsbh   nsrxm      zjid  gfr  gfrzjhm   fwyt  jzmj  合同签订日期htqdrq   jtyyzfts套数
        //qszsmc  qsjsje  qsjssl  qsyjje
        //yhszsmc  yhsjsje  yhsjssl  yhsyjje   hjyjje  hjyjjedx
         _headerArray = @[@" ",@"契税",@"印花税"];
    }else if ([self.title isEqualToString:@"维修资金缴纳"]) {
        _dataArray = @[@[@"名称",@"证件号码",@"项目名称",@"物业类型",@"房屋坐落",@"建筑面积（㎡）",@"缴交标准（元）"],
                       @[@"账户名称",@"开户行",@"账号",@"应缴金额（元）",@"应缴金额（大写）"]
                       ];
        [self customAddContentWith:@[@"gfr",@"gfrzjhm",@"xmmc",@"wylx",@"zlms",@"jzmj",@"jjbz"
                                     ,@"hrzhmc",@"hrzhkhh",@"hrzhkhh",@"yjje",@"yjjedx"
                                    ]];
        //ywzh
        //gfr   gfrzjhm  xmmc   wylx   zlms   jzmj   jjbz
        
        //hryhzh 资金汇入账号         yjje  yjjedx  hrzhmc hrzhkhh
        _headerArray = @[@"业主信息",@"账户信息"];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_contentArray.count) {
        return 0;
    }
    if (section == 0) {//图片
        return 1;
    }
   
    return [_dataArray[section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        MyHouseTaxHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxHeaderCell" forIndexPath:indexPath];
        if ([self.title isEqualToString:@"房款缴纳"]) {
            cell.logoIMageView.image = [UIImage imageNamed:@"house_house"];
        }else if ([self.title isEqualToString:@"税额缴纳"]) { // jkqx
            cell.logoIMageView.image = [UIImage imageNamed:@"house_tax"];
        }else if ([self.title isEqualToString:@"维修资金缴纳"]) {
            cell.logoIMageView.image = [UIImage imageNamed:@"house_fix"];
        }
        cell.contentLabel.text = [NSString stringWithFormat:@"合同编号：%@",self.htbh];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NSString *title = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section-1][indexPath.row]];
    NSInteger cunstomRow = indexPath.row;

    for (int i=0; i<_dataArray.count; i++) {
        if (i<indexPath.section-1) {
           cunstomRow = cunstomRow+[_dataArray[i] count];
        }
    }
    if ([title isEqualToString:@"合计（小写）"]||[title isEqualToString:@"合计（大写）"]
        ||[title isEqualToString:@"应缴金额（元）"]||[title isEqualToString:@"应缴金额（大写）"]
        ) {
        MyHouseTaxContentBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxContentBottomCell" forIndexPath:indexPath];
        cell.titleLabel.text = title;
        cell.contentLabel.text = _contentArray[cunstomRow];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    MyHouseTaxContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxContentCell" forIndexPath:indexPath];
    cell.titleLabel.text = title;
    cell.contentLabel.text = _contentArray[cunstomRow];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section-1<0||_headerArray.count == 0) {
        return 0.01;
    }
    NSString *strHeader = _headerArray[section-1];
    if (strHeader==nil ||!strHeader.length) {
        return 0.01;
    }
    if (strHeader.length == 1) {
        return 10.0;
    }
    return 46.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section-1<0||_headerArray.count == 0) {
        return [UIView new];
    }
    NSString *strHeader = _headerArray[section-1];
    if (strHeader==nil ||!strHeader.length) {
        return [UIView new];
    }
    MuHouseDetialHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MuHouseDetialHeader"];
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.bottomLine.hidden = YES;
    header.headerButton.hidden = YES;
    header.titleBottom.constant = 10;
    header.headerTitle.text = strHeader;
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 5.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)initView{
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kListBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxContentCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxContentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxContentBottomCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxContentBottomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxHeaderCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MuHouseDetialHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"MuHouseDetialHeader"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (_dataDic[@"url"] != nil) {//hpdVo
        MyHouseBottomPapaer *footer = [[NSBundle mainBundle] loadNibNamed:@"MyHouseBottomPapaer" owner:self options:nil].firstObject;
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        footer.url =  _dataDic[@"url"];
        self.tableView.tableFooterView = footer;
    }
    if ( [_dataDic[@"hpdVo"] count]>0) {//hpdVo
        MyHouseBottomPapaer *footer = [[NSBundle mainBundle] loadNibNamed:@"MyHouseBottomPapaer" owner:self options:nil].firstObject;
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
        footer.detialArray =  _dataDic[@"hpdVo"];
        self.tableView.tableFooterView = footer;
    }
}
- (IBAction)codeClick:(id)sender {
    
    if ([self.dataDic[@"jnbz"] integerValue] == 1) {
        [SVProgressHelper dismissWithMsg:[NSString stringWithFormat:@"%@已完成",self.title]];
        return;
    }
    MyHouseCodeViewController *vc = [MyHouseCodeViewController new];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        vc.codeStr = [NSString stringWithFormat:@"%@",self.dataDic[@"qrcode"]];
    });
    vc.pramDic = @{@"paytype":[NSString stringWithFormat:@"%@",self.dataDic[@"paytype"]],
                 @"qybh":[NSString stringWithFormat:@"%@",self.dataDic[@"qybh"]],
                 @"htbh":[NSString stringWithFormat:@"%@",self.htbh]
                 };
    [self.navigationController pushViewController:vc animated:YES];
}
@end
