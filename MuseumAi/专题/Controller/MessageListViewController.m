//
//  MessageListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MessageListViewController.h"
#import "SysMesssageTableViewCell.h"
#import "CloudWebController.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "NewsModel.h"
#import "ZTDetialViewController.h"
#import "HomePageHousesCollectionViewCell.h"

@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation MessageListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"常见问题";
    self.view.backgroundColor = kListBgColor;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -[Utility segmentTopMinHeight]-42)];
    [self.view addSubview:self.tableView];
    self.tableView.alwaysBounceVertical = YES;
//    self.tableView.alwaysBounceHorizontal = YES;
    self.tableView.backgroundColor = kListBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SysMesssageTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"SysMesssageTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomePageHousesCollectionViewCell class])  bundle:nil] forCellReuseIdentifier:@"HomePageHousesCollectionViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf reloadData];
    }];
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.page++;
//        [weakSelf reloadData];
//    }];
    
    self.allView = self.tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SysMesssageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMesssageTableViewCell" forIndexPath:indexPath];
    NewsModel *tempModel = _dataArray[indexPath.row];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",tempModel.bt];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",tempModel.fbsj];
    cell.titleLabel.text = @"系统消息";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsModel *tempModel = _dataArray[indexPath.row];
    ZTDetialViewController *vc = [ZTDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.formatString = tempModel.nr;
    vc.title = self.title;
//    if (tempModel.title.length == 0) {
//        vc.title = tempModel.bt;
//    }
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


- (void)reloadData {
    NSString *flStr = @"1";
    NSString *strURL = @"/api/family/xf/user/xtinform";
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(strURL) para: @{@"page":@"1",@"rows":@"999"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            weakSelf.dataArray = [NewsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.dataArray.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

@end
