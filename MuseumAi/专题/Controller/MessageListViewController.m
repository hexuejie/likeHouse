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

@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic , assign) NSInteger page;
@end

@implementation MessageListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"常见问题";
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"}];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -[Utility segmentTopMinHeight]-42)];
    [self.view addSubview:self.tableView];
    self.tableView.alwaysBounceVertical = YES;
//    self.tableView.alwaysBounceHorizontal = YES;
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SysMesssageTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"SysMesssageTableViewCell"];
    //    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCenterLoginOutTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyCenterLoginOutTableViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
//    __weak typeof (self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        weakSelf.page = 1;
////        [weakSelf.tableView.mj_footer resetNoMoreData];
////        [weakSelf reloadData];
//    }];
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
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CloudWebController *vc = [CloudWebController new];
    vc.title = @"消息详情";
    vc.requestURL = @"http://10.3.61.154/sales/7";
    vc.hidesBottomBarWhenPushed = YES;
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
    NSString *strURL = @"/api/family/xf/user/marketnewslist";
    if ([self.title isEqualToString:@"楼盘动态"]) {
        flStr = @"2";
        strURL = @"/api/family/xf/user/baikejzlist";
    }else if ([self.title isEqualToString:@"悦居资讯"]) {
        flStr = @"";
        strURL = @"/api/family/xf/user/baikejzlist";
    }
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(strURL) para: @{@"fl":flStr//2
                                                                        ,@"page":@"1",@"rows":@"999"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
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
