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
//@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation HouseAroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"位置周边";
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HouseAroundTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"HouseAroundTableViewCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetialMoreHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"DetialMoreHeader"];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _zbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HouseAroundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseAroundTableViewCell" forIndexPath:indexPath];
    
//    cell.contentLabel.text = _zbArray[indexPath.row][@"zbmc"];
//

    switch ([_zbArray[indexPath.row][@"zblx"] integerValue]) {
            
        case 1:{
            cell.titleLabel.text = @"学校";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_school"];
        }break;
            
        case 2:{
            cell.titleLabel.text = @"地铁";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_metro"];
        }break;
            
        case 3:{
            cell.titleLabel.text = @"公交";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_bus"];
        }break;
            
        case 4:{
            cell.titleLabel.text = @"医院";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_hospital"];
        }break;
            
        case 5:{
            cell.titleLabel.text = @"银行";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_bank"];
        }break;
            
        case 6:{
            cell.titleLabel.text = @"商圈";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_shop"];
        }break;
            
        case 7:{
            cell.titleLabel.text = @"其他";
            cell.titleLogoImage.image = [UIImage imageNamed:@"detial_other"];
        }break;
            
//   1 学校 2 地铁 3 公交  4 医院  5 银行  6 商圈  7 其他
        default:
            break;
    }
//    zblst
    cell.itemArray = _zbArray[indexPath.row][@"zblst"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)setZbArray:(NSArray *)zbArray{
    _zbArray = zbArray;
    
    [self.tableView reloadData];
    
    if (self.zbArray.count == 0) {
        [self addNoneDataTipView];
    }
}

@end
