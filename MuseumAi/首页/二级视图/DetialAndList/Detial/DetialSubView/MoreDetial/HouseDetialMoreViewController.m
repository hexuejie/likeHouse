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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetialMoreTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"DetialMoreTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetialMoreHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"DetialMoreHeader"];
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"DetialMoreHeaderView" owner:self options:nil].firstObject;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.tableView.tableHeaderView = self.headerView;
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
    
    DetialMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetialMoreTableViewCell" forIndexPath:indexPath];
  
    cell.contentLabel.text = _dataArray[indexPath.row][@"title"];
    
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
    return header;
}

@end
