//
//  AddChildrenListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AddChildrenListViewController.h"
#import "AddChildrenViewController.h"
#import "ChooseOtherRealViewController.h"
#import "AddChildrenTableViewCell.h"
#import "RealChooseHKViewController.h"
#import "RealChooseForeignViewController.h"

@interface AddChildrenListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectArray;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (strong, nonatomic) UIButton *rigthButton;
@end

@implementation AddChildrenListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self customReloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加子女信息";
    
    self.selectArray = [NSMutableArray new];
    self.tableView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddChildrenTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"AddChildrenTableViewCell"];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    

    _rigthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [_rigthButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_rigthButton setTitle:@"取消" forState:UIControlStateSelected];
    [_rigthButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
    [_rigthButton addTarget:self action:@selector(tightViewClear:) forControlEvents:UIControlEventTouchUpInside];
    _rigthButton.titleLabel.font = kSysFont(16);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rigthButton];
}
- (IBAction)addChildrenClick:(id)sender {
    if (self.bottomButton.selected) {
        self.bottomButton.userInteractionEnabled = NO;
        [self delznxxRequest];
        return;
    }
    
    [LoginSession sharedInstance].pageType = 2;
    [self.navigationController pushViewController:[ChooseOtherRealViewController new] animated:YES];

}
///listznxx
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddChildrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddChildrenTableViewCell" forIndexPath:indexPath];
    NSDictionary *tempDic = _dataArray[indexPath.row];
    cell.nameLabel.text = tempDic[@"jtcy"][@"xm"];
    cell.chooseButton.hidden = YES;
    if (self.bottomButton.selected) {
        cell.chooseButton.hidden = NO;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.bottomButton.selected) {
        AddChildrenTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chooseButton.selected =  !cell.chooseButton.selected;
//        [self.tableView reloadData];
        return;
    }
    [LoginSession sharedInstance].pageType = 2;
    NSDictionary *tempDic = _dataArray[indexPath.row];
    [LoginSession sharedInstance].otherYhbh = tempDic[@"jtcy"][@"yhbh"];
    if ([LoginSession sharedInstance].otherYhbh == nil) {
        [LoginSession sharedInstance].otherYhbh = @"";
    }
    NSString *zjlxStr = [NSString stringWithFormat:@"%@",tempDic[@"jtcy"][@"zjlx"]];
    if(zjlxStr != nil){
        if([zjlxStr isEqualToString:@"港澳台来往大陆通行证"]){
            RealChooseHKViewController *vc = [RealChooseHKViewController new];
            vc.personData = [PersonModel mj_objectWithKeyValues:tempDic];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else if([zjlxStr isEqualToString:@"护照"]){
            RealChooseForeignViewController *vc = [RealChooseForeignViewController new];
            vc.personData = [PersonModel mj_objectWithKeyValues:tempDic];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }else if([zjlxStr isEqualToString:@"户口薄"]||[zjlxStr isEqualToString:@"身份证"]){
            AddChildrenViewController *vc = [AddChildrenViewController new];
            vc.personData = [PersonModel mj_objectWithKeyValues:tempDic];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }
    
    ChooseOtherRealViewController *vc = [ChooseOtherRealViewController new];
//    vc.dataDic = tempDic;//回填
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customReloadData {
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/listznxx") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            weakSelf.dataArray = response[@"data"];
            if ( weakSelf.dataArray.count>0) {
                weakSelf.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.tableView.hidden = YES;
            }
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)delznxxRequest{
    NSString *stryhbh;
    for (int i = 0; i<_dataArray.count; i++) {
        NSDictionary *tempDic = _dataArray[i];
        AddChildrenTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.chooseButton.selected == YES) {
            if (stryhbh.length == 0) {
                stryhbh = [NSString stringWithFormat:@"%@",tempDic[@"jtcy"][@"yhbh"]];
            }else{
               stryhbh = [NSString stringWithFormat:@"%@,%@",stryhbh,tempDic[@"jtcy"][@"yhbh"]];
            }
            
        }
    }
    if (stryhbh.length == 0) {
        [SVProgressHelper dismissWithMsg:@"请选择要删除信息！"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/delznxx") para:@{@"yhbh":stryhbh} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            [SVProgressHelper dismissWithMsg:@"信息删除成功！"];
            [weakSelf tightViewClear:weakSelf.rigthButton];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
        weakSelf.bottomButton.userInteractionEnabled = YES;
    }];
}


- (void)tightViewClear:(UIButton *)button{
    button.selected = !button.selected;
    
    self.bottomButton.selected = button.selected;
    if (button.selected) {
        [self.tableView reloadData];
    }else{
        [self customReloadData];
    }
}
@end
