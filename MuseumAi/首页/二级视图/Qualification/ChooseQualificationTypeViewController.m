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
#import "ChooseOtherRealViewController.h"
#import "ResultQualityViewController.h"
#import "ChooseMySelfAndRealViewController.h"

@interface ChooseQualificationTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSDictionary *dataDic;

@property (assign, nonatomic) BOOL grxx;
@property (assign, nonatomic) BOOL poxx;
@property (assign, nonatomic) BOOL znxx;
@property (assign, nonatomic) BOOL bcxx;

@end

@implementation ChooseQualificationTypeViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [LoginSession sharedInstance].otherYhbh = @"";
}

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
    cell.chooseButton.selected = NO;
    if (indexPath.row == 0 && self.grxx) cell.chooseButton.selected = YES;
    if (indexPath.row == 1 && self.poxx) cell.chooseButton.selected = YES;
    if (indexPath.row == 2 && self.znxx) cell.chooseButton.selected = YES;
    if (indexPath.row == 3 && self.bcxx) cell.chooseButton.selected = YES;
    
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
                if ([LoginSession sharedInstance].rzzt) {
                    [self.navigationController pushViewController:[ChooseAddMyselfVC new] animated:YES];
                }else{
                    [self.navigationController pushViewController:[ChooseMySelfAndRealViewController new] animated:YES];
                }
                
            }break;
        case 1:
        {
            if ( [self.dataDic[@"jtcy"][@"hyzk"] isEqualToString:@"未婚"]) {
                [SVProgressHelper dismissWithMsg:@"当前婚姻状况为未婚，不需要添加配偶信息"];
                return;
            }
            if ( self.dataDic[@"jtcy"][@"hyzk"] == nil) {
                [SVProgressHelper dismissWithMsg:@"请先添加申购人信息"];
                return;
            }
            [LoginSession sharedInstance].pageType = 1;
            [self.navigationController pushViewController:[ChooseOtherRealViewController new] animated:YES];
//             [self.navigationController pushViewController:[ChooseAddMateshipViewController new] animated:YES];
        }break;
        case 2:
        {
            if ( self.dataDic[@"jtcy"][@"hyzk"] == nil) {
                [SVProgressHelper dismissWithMsg:@"请先添加申购人信息"];
                return;
            }
            [self.navigationController pushViewController:[AddChildrenListViewController new] animated:YES];
            
        }break;
        case 3:
        {
            if ( self.dataDic[@"jtcy"][@"hyzk"] == nil) {
                [SVProgressHelper dismissWithMsg:@"请先添加申购人信息"];
                return;
            }
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
    if (self.dataDic[@"jtcy"][@"hyzk"] == nil || [self.dataDic[@"jtcy"][@"hyzk"] isEqualToString:@""]) {
        [SVProgressHelper dismissWithMsg:@"您还未添加任何信息"];
        return;
    }
    if ( [self.dataDic[@"jtcy"][@"hyzk"] isEqualToString:@"已婚"] && self.poxx == NO) {
        [SVProgressHelper dismissWithMsg:@"请完善配偶信息"];
        return;
    }

    ResultQualityViewController *vc = [ResultQualityViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isReal = NO;
    vc.isSubmit = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customReload];
}

- (void)customReload {
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/step") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
           weakSelf.dataDic = response[@"data"];
            
            if (![Utility is_empty:weakSelf.dataDic[@"grxx"]]) {
                weakSelf.grxx = [weakSelf.dataDic[@"grxx"] boolValue];
            }
            if (![Utility is_empty:weakSelf.dataDic[@"poxx"]]) {
                weakSelf.poxx = [weakSelf.dataDic[@"poxx"] boolValue];
            }
            if (![Utility is_empty:weakSelf.dataDic[@"znxx"]]) {
                weakSelf.znxx = [weakSelf.dataDic[@"znxx"] boolValue];
            }
            if (![Utility is_empty:weakSelf.dataDic[@"bcxx"]]) {
                weakSelf.bcxx = [weakSelf.dataDic[@"bcxx"] boolValue];
            }
            
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/allmessage/new") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            NSDictionary *allDic = response[@"data"];
            [PersonInfo sharedInstance].allmessageDic = allDic;
        }else{
        }
    }];
}

@end
