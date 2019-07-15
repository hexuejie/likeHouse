//
//  QuesttionListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "QuesttionListViewController.h"
#import "QuestionListTableViewCell.h"
#import "CloudWebController.h"
#import "QuestionDetialViewController.h"

@interface QuesttionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation QuesttionListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"常见问题";
    self.view.backgroundColor = kListBgColor;
   
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kListBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"QuestionListTableViewCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCenterLoginOutTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyCenterLoginOutTableViewCell"];
   
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionListTableViewCell" forIndexPath:indexPath];
    
    [cell.orderButton setTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1] forState:UIControlStateNormal];
    cell.contentLabel.text = _dataArray[indexPath.row][@"wtbt"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionDetialViewController *vc = [QuestionDetialViewController new];
    vc.title = @"问题详情";
    vc.dataDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 17.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (void)reloadData{
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/questions") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
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
