//
//  HouseAroundViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseAroundViewController.h"
#import "HouseAroundTableViewCell.h"

@interface HouseAroundViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation HouseAroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"位置周边";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"},
                   @{@"title":@"用户设置",@"content":@"myCenter_setting"},
                   @{@"title":@"关于悦居星城",@"content":@"myCenter_about"},
                   @{@"title":@"添加前配偶需要哪些信息？",@"content":@"myCenter_setting"},
                   @{@"title":@"添加前配偶需要哪些信息？添加前配偶需要哪些信息？",@"content":@"myCenter_about"}
                   ];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HouseAroundTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"HouseAroundTableViewCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetialMoreHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"DetialMoreHeader"];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
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
    
    HouseAroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseAroundTableViewCell" forIndexPath:indexPath];
    
    cell.contentLabel.text = _dataArray[indexPath.row][@"title"];
    
    
    if (cell.contentLabel.text.length > 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.contentLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4; // 调整行间距
        NSRange range = NSMakeRange(0, [cell.contentLabel.text length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [cell.contentLabel setAttributedText:attributedString];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


@end
