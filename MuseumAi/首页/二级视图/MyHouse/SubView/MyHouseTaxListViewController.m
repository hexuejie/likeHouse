//
//  MyHouseTaxListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/15.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseTaxListViewController.h"
#import "MyHouseTaxListTableViewCell.h"
#import "MyHouseTaxHeaderSection.h"

@interface MyHouseTaxListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MyHouseTaxListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kUIColorFromRGB(0xffffff);
//    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xffffff);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyHouseTaxListTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHouseTaxHeaderSection class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"MyHouseTaxHeaderSection"];
    
//    _detialArray = @[@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"},@{@"jgzh":@"12312412"}];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _detialArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *tempDic = _detialArray[section];
    if ([tempDic[@"selected"] isEqualToString:@"1"]) {
        return 1;
    }else{
      return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyHouseTaxListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyHouseTaxListTableViewCell" forIndexPath:indexPath];
    NSDictionary *tempDic = _detialArray[indexPath.section];
    cell.contentLabel1.text = tempDic[@"jgzh"];
    cell.contentLabel2.text = tempDic[@"jylsh"];
    cell.contentLabel3.text = tempDic[@"yhkh"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 84;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *tempDic = _detialArray[section];
    MyHouseTaxHeaderSection *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MyHouseTaxHeaderSection"];
    header.priceLabel.text = [NSString stringWithFormat:@"-%@",[self stringWithCharmCount:tempDic[@"zfje"]]];
    header.timeLabel.text = [NSString stringWithFormat:@"%@",tempDic[@"jyrq"]];
    
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.clickButton.tag = section;
    if ([tempDic[@"selected"] isEqualToString:@"1"]) {
        header.clickButton.selected = YES;
    }else{
        header.clickButton.selected = NO;
    }
    [header.clickButton addTarget:self action:@selector(clickButtonselect:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

- (void)clickButtonselect:(UIButton *)button{
    NSMutableArray *tempArray = [_detialArray mutableCopy];
     NSMutableDictionary *tempDic = [_detialArray[button.tag] mutableCopy];
    if ([tempDic[@"selected"] isEqualToString:@"1"]) {
        [tempDic setObject:@"0" forKey:@"selected"];
    }else{
        [tempDic setObject:@"1" forKey:@"selected"];
    }
    [tempArray setObject:tempDic atIndexedSubscript:button.tag];
    _detialArray = tempArray;
    [self.tableView reloadData];
//    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationNone];
}


- (NSString *)stringWithCharmCount:(NSString *)charmCount
{
    charmCount = [NSString stringWithFormat:@"%@",charmCount];
    //将要分割的字符串变为可变字符串
    NSMutableString *countMutStr = [[NSMutableString alloc]initWithString:charmCount];
    //字符串长度
    NSInteger length = countMutStr.length;
    //除数
    NSInteger divisor = length/3;
    //余数
    NSInteger remainder = length%3;
    //有多少个逗号
    NSInteger commaCount;
    if (remainder == 0) {   //当余数为0的时候，除数-1==逗号数量
        commaCount = divisor - 1;
    }else{  //否则 除数==逗号数量
        commaCount = divisor;
    }
    //根据逗号数量，for循环依次添加逗号进行分隔
    for (int i = 1; i<commaCount+1; i++) {
        [countMutStr insertString:@"," atIndex:length - i * 3];
    }
    return countMutStr;
}
@end
