//
//  AppendOneListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AppendOneListViewController.h"
#import "ChooseAppendViewController.h"
#import "AddChildrenTableViewCell.h"

@interface AppendOneListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@property (strong, nonatomic) UIButton *rigthButton;
@end

@implementation AppendOneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加特殊人才";
    
    self.addButton.userInteractionEnabled = YES;
    [self.addButton addTarget:self action:@selector(addPersonClick:) forControlEvents:UIControlEventTouchUpInside];
    
  
    self.tableView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddChildrenTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"AddChildrenTableViewCell"];
    self.view.userInteractionEnabled =YES;
    
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

- (IBAction)addPersonClick:(id)sender {
    if (self.addButton.selected) {
        self.addButton.userInteractionEnabled = NO;
        [self delznxxRequest];
        return;
    }
    [self.navigationController pushViewController:[ChooseAppendViewController new] animated:YES];
}
///listznxx
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddChildrenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddChildrenTableViewCell" forIndexPath:indexPath];
    NSDictionary *tempDic = _dataArray[indexPath.row];
    cell.nameLabel.text = tempDic[@"xm"];
    cell.chooseButton.hidden = YES;
    if (self.addButton.selected) {
        cell.chooseButton.hidden = NO;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.addButton.selected) {
        AddChildrenTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chooseButton.selected =  !cell.chooseButton.selected;
        //        [self.tableView reloadData];
        return;
    }
    
    
    NSDictionary *tempDic = _dataArray[indexPath.row];
    [LoginSession sharedInstance].otherYhbh = tempDic[@"yhbh"];
    if ([LoginSession sharedInstance].otherYhbh == nil) {
        [LoginSession sharedInstance].otherYhbh = @"";
    }
    
   
    ChooseAppendViewController *vc = [ChooseAppendViewController new];
    NSArray *tempArr = [PersonInfo sharedInstance].allmessageDic[@"tsrcList"];
    if (tempArr.count>indexPath.row) {
        vc.addmodel = [AddOtherModel mj_objectWithKeyValues:tempArr[indexPath.row]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/tsrclist") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
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
                stryhbh = [NSString stringWithFormat:@"%@",tempDic[@"yhbh"]];
            }else{
                stryhbh = [NSString stringWithFormat:@"%@,%@",stryhbh,tempDic[@"yhbh"]];
            }
            
        }
    }
    if (stryhbh.length == 0) {
        [SVProgressHelper dismissWithMsg:@"请选择要删除信息！"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/deltsrc") para:@{@"yhbh":stryhbh} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            [SVProgressHelper dismissWithMsg:@"信息删除成功！"];
            [weakSelf tightViewClear:weakSelf.rigthButton];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
        weakSelf.addButton.userInteractionEnabled = YES;
    }];
}


- (void)tightViewClear:(UIButton *)button{
    button.selected = !button.selected;
    
    self.addButton.selected = button.selected;
    if (button.selected) {
        [self.tableView reloadData];
    }else{
        [self reloadData];
    }
}
@end
