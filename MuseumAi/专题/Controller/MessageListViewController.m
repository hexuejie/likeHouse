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
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"},
                   @{@"title":@"用户设置",@"content":@"myCenter_setting"},
                   @{@"title":@"关于悦居星城",@"content":@"myCenter_about"},
                   @{@"title":@"添加前配偶需要哪些信息？",@"content":@"myCenter_setting"},
                   @{@"title":@"添加前配偶需要哪些信息？添加前配偶需要哪些信息？",@"content":@"myCenter_about"}
                   ];
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


@end
