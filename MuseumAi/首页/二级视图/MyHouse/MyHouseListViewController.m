//
//  MyHouseListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/17.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseListViewController.h"
#import "MyHouseListTableViewCell.h"
#import "CloudWebController.h"
#import "MyHouseDetialViewController.h"

@interface MyHouseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MyHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的购房";
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"}
                   ];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseListTableViewCell"];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
//    [self addNoneDataTipView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyHouseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseListTableViewCell" forIndexPath:indexPath];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyHouseDetialViewController *vc = [MyHouseDetialViewController new];
    vc.title = @"购房信息";
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


@end
