//
//  MyHouseDetialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseDetialViewController.h"
#import "MyHouseDetialOneCell.h"
#import "MyHouseDetialTwoCell.h"
#import "MuHouseDetialHeader.h"
#import "MyHouseTaxViewController.h"
#import "MyHouseCodeViewController.h"

@interface MyHouseDetialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIButton *codeImageButton;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MyHouseDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的购房";
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改购房资格审查资料修改",@"content":@"myCenter_change"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"}
                   ];
    [self initView];
    
    //    [self addNoneDataTipView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >=2 &&indexPath.row == 0) {
        MyHouseDetialTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseDetialTwoCell" forIndexPath:indexPath];
        cell.headerButton.tag = indexPath.row;
        [cell.headerButton addTarget:self action:@selector(headerButtonToFix:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    MyHouseDetialOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseDetialOneCell" forIndexPath:indexPath];
    cell.secondTag = NO;
    if (indexPath.row == 1) {
        cell.secondTag = YES;//有两个
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)headerButtonToFix:(UIButton *)button{
    
    MyHouseTaxViewController *vc = [MyHouseTaxViewController new];
    vc.title = @"税额缴纳";
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section <=2) {
        if (section == 0) {
            return 60;
        }
        return 54.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section <=2) {
        MuHouseDetialHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MuHouseDetialHeader"];
        header.contentView.backgroundColor = [UIColor whiteColor];
        header.bottomLine.hidden = NO;
        if (section == 2) {
            header.bottomLine.hidden = YES;
        }
        if (section != 1) {
            header.headerButton.hidden = YES;
        }else{
            header.headerButton.hidden = NO;
        }
        return header;
    }
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0||section == 1) {
        return 10.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)initView{
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.codeImageButton = [[UIButton alloc]init];
    [self.codeImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeImageButton addTarget:self action:@selector(pushToMyHouseCodeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.codeImageButton setTitle:@"缴款二维码" forState:UIControlStateNormal];
    self.codeImageButton .backgroundColor =  kUIColorFromRGB(0xC0905D);
    self.codeImageButton.titleLabel.font = kSysFont(17.0);
    self.codeImageButton.layer.cornerRadius = 2.0;
    self.codeImageButton.clipsToBounds = YES;
    [self.view addSubview:self.codeImageButton];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-0);
        make.leading.equalTo(self.view).offset(0);
        make.trailing.equalTo(self.view).offset(-0);
        make.height.mas_equalTo(70);
    }];
    [self.codeImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-23);
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseDetialOneCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseDetialOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseDetialTwoCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseDetialTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MuHouseDetialHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"MuHouseDetialHeader"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.codeImageButton.mas_top).offset(-3);
        make.leading.trailing.top.equalTo(self.view).offset(0);
    }];
}

- (void)pushToMyHouseCodeViewController{
    MyHouseCodeViewController *vc = [MyHouseCodeViewController new];
    vc.title = @"税额缴纳";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
