//
//  MyHouseTaxViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseTaxViewController.h"
#import "MyHouseTaxContentCell.h"
#import "MyHouseTaxContentBottomCell.h"
#import "MyHouseTaxHeaderCell.h"
#import "MuHouseDetialHeader.h"
#import "MyHouseCodeViewController.h"

@interface MyHouseTaxViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MyHouseTaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"税额缴纳";
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        MyHouseTaxHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxHeaderCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section >=2 &&indexPath.row >= 5) {
        MyHouseTaxContentBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxContentBottomCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    MyHouseTaxContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxContentCell" forIndexPath:indexPath];
//    cell.secondTag = NO;
//    if (indexPath.row == 1) {
//        cell.secondTag = YES;//有两个
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 46.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }
    MuHouseDetialHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MuHouseDetialHeader"];
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.bottomLine.hidden = YES;
    header.headerButton.hidden = YES;
    header.titleBottom.constant = 10;
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 5.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)initView{
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxContentCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxContentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxContentBottomCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxContentBottomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxHeaderCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MuHouseDetialHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"MuHouseDetialHeader"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];

}
- (IBAction)codeClick:(id)sender {
    MyHouseCodeViewController *vc = [MyHouseCodeViewController new];
    vc.title = @"税额缴纳";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
