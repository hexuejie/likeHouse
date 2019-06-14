//
//  ChooseQualificationTypeViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseQualificationTypeViewController.h"
#import "ChooseQualificationTableViewCell.h"
#import "ChooseAddMyselfVC.h"
#import "ChooseAddMateshipViewController.h"
#import "AddChildrenViewController.h"
#import "AddChildrenListViewController.h"
#import "AppendChooseViewController.h"

@interface ChooseQualificationTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation ChooseQualificationTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"购房资格申请";
    _dataArray = @[@{@"title":@"添加申购人信息",@"content":@"完善个人婚姻和户口状况"},@{@"title":@"添加配偶信息",@"content":@"已婚或离异请添加"},
                   @{@"title":@"添加子女信息",@"content":@"请添加您的未成年子女信息，如子女已成年或尚没有子女，请跳过"},@{@"title":@"添加补充信息",@"content":@"征收家庭，省直机关社保，特殊人才"}
                   ];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseQualificationTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"ChooseQualificationTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.selec = UITableViewCellSelectionStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseQualificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseQualificationTableViewCell" forIndexPath:indexPath];
    cell.headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"qualification_qualification%ld",indexPath.row+1]];
    
    NSDictionary *tempDic = _dataArray[indexPath.row];
    cell.titleLabel.text = tempDic[@"title"];
    cell.contentLabel.text = tempDic[@"content"];
    cell.chooseButton.tag = indexPath.row+100;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 120.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            {
                [self.navigationController pushViewController:[ChooseAddMyselfVC new] animated:YES];
            }break;
        case 1:
        {
             [self.navigationController pushViewController:[ChooseAddMateshipViewController new] animated:YES];
        }break;
        case 2:
        {
            [self.navigationController pushViewController:[AddChildrenListViewController new] animated:YES];
            
        }break;
        case 3:
        {
            [self.navigationController pushViewController:[AppendChooseViewController new] animated:YES];
        }break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (IBAction)nextStepClick:(id)sender {
    if (0) {
        
        [SVProgressHelper dismissWithMsg:@"当前婚姻状况为未婚，不需要添加配偶信息"];
        return;
    }else if (1) {
        [SVProgressHelper dismissWithMsg:@"请完善配偶信息"];
        return;
    }

    
}
@end
