//
//  BuildingDetialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "BuildingDetialViewController.h"
#import "DetialMoreHeader.h"
#import "DetialMoreHeaderView.h"
#import "BuildingListTableViewCell.h"
#import "BuildingListHeader.h"
#import "BuildingDetialMoreViewController.h"

@interface BuildingDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation BuildingDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"楼栋信息";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = @[];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuildingListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"BuildingListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuildingListHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"BuildingListHeader"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = _dataArray[section];
    NSArray *tempArray = dic[@"info"];
    return tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BuildingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingListTableViewCell" forIndexPath:indexPath];
    
//    cell.contentLabel.text = _dataArray[indexPath.row][@"title"];
    NSDictionary *dic = _dataArray[indexPath.section];
    NSArray *tempArray = dic[@"info"];
    NSDictionary *tempDic = tempArray[indexPath.row];
    cell.dhLabel.text = tempDic[@"dh"];
    cell.ztLabel.text = tempDic[@"zt"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 52;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    BuildingListHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BuildingListHeader"];
    header.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = _dataArray[section];
    header.titleNameLabel.text = dic[@"ssqs"];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[BuildingDetialMoreViewController new] animated:YES];
}


- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    if (!_strBH) {
        _strBH = @"";
    }//xqly Integer 详情来源  (1,banner,2,专题,3,新闻,4,推荐,5,其他)
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/buildinfo") para:@{@"saleid":_strBH} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            weakSelf.dataArray = response[@"data"];
//            weakSelf.detialModel.dataDic = response[@"data"];
            
            [weakSelf.tableView reloadData];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
        }
   
    }];
}

@end
