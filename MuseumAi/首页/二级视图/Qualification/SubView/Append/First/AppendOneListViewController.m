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
}

- (IBAction)addPersonClick:(id)sender {
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDic = _dataArray[indexPath.row];
    [LoginSession sharedInstance].otherYhbh = tempDic[@"yhbh"];
    if ([LoginSession sharedInstance].otherYhbh == nil) {
        [LoginSession sharedInstance].otherYhbh = @"";
    }
    
    ChooseAppendViewController *vc = [ChooseAppendViewController new];
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
@end
