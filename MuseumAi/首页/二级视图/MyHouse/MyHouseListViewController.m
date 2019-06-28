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
#import "MyHouseMode.h"

@interface MyHouseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation MyHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的购房";
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    _dataArray = [NSMutableArray new];
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
    
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyHouseDetialViewController *vc = [MyHouseDetialViewController new];
    vc.title = @"购房信息";
    vc.model = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}//mj_keyValues
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


#pragma mark - request
- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    self.dataArray = [NSMutableArray new];

    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/contract/list") para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
   
            for (NSDictionary *tempdic in response[@"data"]) {
                [weakSelf.dataArray addObject:[MyHouseMode mj_objectWithKeyValues:tempdic]];
            }
        
            [weakSelf.tableView reloadData];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
            [weakSelf addNoneDataTipView];
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}
@end
