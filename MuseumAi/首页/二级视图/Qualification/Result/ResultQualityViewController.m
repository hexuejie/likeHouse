//
//  ResultQualityViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ResultQualityViewController.h"
#import "AddMateShipTableViewCell.h"
#import "ResultQualityHeader.h"
#import "ResultImageTableViewCell.h"

@interface ResultQualityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomLay;

@property (nonatomic , strong) RealFinishTipView1 *tipView1;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ResultQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"购房资格";
    self.tableBottomLay.constant = 0;

    _dataArray = @[@{@"title":@"浏览记录",@"content":@"myCenter_footer"},
                   @{@"title":@"常见问题",@"content":@"myCenter_question"},
                   @{@"title":@"用户设置",@"content":@"myCenter_setting"},
                   @{@"title":@"关于悦居星城",@"content":@"myCenter_about"},
                   @{@"title":@"添要哪些信息？",@"content":@"myCenter_setting"},
                 
                   @{@"image":@[@"http://img.findlawimg.com/info/2019/0610/20190610114035328.jpg",@"http://img.findlawimg.com/info/2019/0610/20190610114035328.jpg"]},
                   @{@"image":@""}
                   ];


    [self.tableview registerClass:[ResultImageTableViewCell class] forCellReuseIdentifier:@"ResultImageTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([AddMateShipTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"AddMateShipTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([ResultQualityHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"ResultQualityHeader"];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 51;
    [self.tableview reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tempDic = _dataArray[indexPath.row];
    
    if ([tempDic[@"image"] isKindOfClass:[NSArray class]]) {
        NSArray *tempImage = tempDic[@"image"];
        NSInteger  count = ceilf(tempImage.count/2.0);
        if (count>0) {
            
            ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
            cell.imageArray = tempImage;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (tempDic[@"title"] != nil) {
        AddMateShipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMateShipTableViewCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = tempDic[@"title"];
        cell.contentTextField.text = tempDic[@"content"];
        cell.contentTextField.textColor = kUIColorFromRGB(0xA8A8A8);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

   
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDic = _dataArray[indexPath.row];
    
    if ([tempDic[@"image"] isKindOfClass:[NSArray class]]) {
        NSArray *tempImage = tempDic[@"image"];
        NSInteger  count = ceilf(tempImage.count/2.0);
        if (count>0) {
            return 23+3+(108 +12)*CustomScreenFit*count;
        }
    }else if (tempDic[@"title"] != nil) {
        return 51;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    ResultQualityHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ResultQualityHeader"];
//    header.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    if (section == 0) {
//        header.headerLabel
        header.headerImageView.hidden = NO;
    }else{
        header.headerImageView.hidden = YES;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    line.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    return  line;
}

- (IBAction)bottomClick:(id)sender {
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    _tipView1.contentTitleLabel.text = @"信息提交后将无法修改，错误信息会导致购房资格审查无法通过，请仔细检查！";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_tipView1.contentTitleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5; // 调整行间距
    NSRange range = NSMakeRange(0, [_tipView1.contentTitleLabel.text length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [_tipView1.contentTitleLabel setAttributedText:attributedString];
    
    [_tipView1.sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确认提交" forState:UIControlStateNormal];
}

- (void)sureClick{///  去网络提交 再弹出
    
    ///  去网络提交 再弹出
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 1;
    
    [_tipView1.sureButton addTarget:self action:@selector(backRootVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backRootVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
