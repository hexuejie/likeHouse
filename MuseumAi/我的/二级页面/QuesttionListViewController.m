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

@interface QuesttionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation QuesttionListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"常见问题";
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"},
                   @{@"title":@"用户设置",@"content":@"myCenter_setting"},
                   @{@"title":@"关于悦居星城",@"content":@"myCenter_about"},
                   @{@"title":@"添加前配偶需要哪些信息？",@"content":@"myCenter_setting"},
                   @{@"title":@"添加前配偶需要哪些信息？添加前配偶需要哪些信息？",@"content":@"myCenter_about"}
                   ];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
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
    
    [cell.orderButton setTitle:[NSString stringWithFormat:@"%ld",indexPath.row] forState:UIControlStateNormal];
    cell.contentLabel.text = _dataArray[indexPath.row][@"title"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CloudWebController *vc = [CloudWebController new];
    vc.title = @"问题详情";
    vc.requestURL = @"http://10.3.61.154/sales/7";
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


@end
