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
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"},
                   @{@"title":@"用户设置",@"content":@"myCenter_setting"},
                   @{@"title":@"关于悦居星城",@"content":@"myCenter_about"},
                   @{@"title":@"添加前配偶需要哪些信息？",@"content":@"myCenter_setting"},
                   @{@"title":@"添加前配偶需要哪些信息？添加前配偶需要哪些信息？",@"content":@"myCenter_about"}
                   ];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuildingListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"BuildingListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BuildingListHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"BuildingListHeader"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BuildingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingListTableViewCell" forIndexPath:indexPath];
    
//    cell.contentLabel.text = _dataArray[indexPath.row][@"title"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 52;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    BuildingListHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BuildingListHeader"];
    header.backgroundColor = [UIColor whiteColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[BuildingDetialMoreViewController new] animated:YES];
}

@end
