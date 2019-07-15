//
//  HouseDetialMoreViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseDetialMoreViewController.h"
#import "DetialMoreHeader.h"
#import "DetialMoreHeaderView.h"
#import "DetialMoreTableViewCell.h"

@interface HouseDetialMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DetialMoreHeaderView *headerView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation HouseDetialMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"楼盘详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetialMoreTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"DetialMoreTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetialMoreHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"DetialMoreHeader"];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"DetialMoreHeaderView" owner:self options:nil].firstObject;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headerView.titleLabel.text = _detialModel.lp.xmmc;
    self.headerView.contentLabel.text = [_detialModel.lp.bq stringByReplacingOccurrencesOfString:@"," withString:@"/"];

    _dataArray = @[
                   @[@{@"title":@"销售状态：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lpzt]}
                     ,@{@"title":@"最新开盘：",@"content":[NSString stringWithFormat:@"%@",_detialModel.kprq]}
                     ,@{@"title":@"楼盘地址：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.xmdz]}]
                   
                   ,@[@{@"title":@"参考价：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.xsqj]}
                      ,@{@"title":@"售楼电话：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.slclxdh]}
                      ,@{@"title":@"预售许可证：",@"content":[NSString stringWithFormat:@"%@",@""]}]//_detialModel.lp.xmbh
                   
                   ,@[@{@"title":@"开发商：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.kfgsmc]}
                      ,@{@"title":@"投资商：",@"content":[NSString stringWithFormat:@"%@",_detialModel.kpxm.kfgsmc]}
                      ,@{@"title":@"容积率：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.rjl]}
                      ,@{@"title":@"绿化率：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.lhl]}
                      ,@{@"title":@"占地面积：",@"content":[NSString stringWithFormat:@"%@",_detialModel.lp.xmzzdmj]}]
                   ];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetialMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetialMoreTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _dataArray[indexPath.section][indexPath.row][@"title"];
    cell.contentLabel.text = _dataArray[indexPath.section][indexPath.row][@"content"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 60;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    DetialMoreHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DetialMoreHeader"];
    header.backgroundColor = [UIColor whiteColor];
    if (section == 1) {
        header.titleLabel.text = @"销售信息";
    }else if (section == 1) {
        header.titleLabel.text = @"建筑规划";
    }
    return header;
}

@end
