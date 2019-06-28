//
//  ResultQualityViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ResultQualityViewController.h"
#import "ResultTitleTableViewCell.h"
#import "ResultContentTableViewCell.h"
#import "ResultQualityHeader.h"
#import "ResultImageTableViewCell.h"
#import "RealFirstTipViewController.h"
#import "PersonModel.h"
#import "AddOtherModel.h"

#define ImagePathMin 19

@interface ResultQualityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomLay;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (nonatomic , strong) RealFinishTipView1 *tipView1;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSDictionary *realData;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContent;

@end

@implementation ResultQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataReset];

    [self.tableview registerClass:[ResultImageTableViewCell class] forCellReuseIdentifier:@"ResultImageTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([ResultContentTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"ResultContentTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([ResultTitleTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"ResultTitleTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([ResultQualityHeader class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"ResultQualityHeader"];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.estimatedRowHeight = 51;
    [self.tableview reloadData];
}

- (void)setIsReal:(BOOL)isReal{
    _isReal = isReal;
    if (_isReal) {
        self.title = @"实名认证";
        if ([[LoginSession sharedInstance].rzzt integerValue] == 3) {
            self.tableBottomLay.constant = 70;
            [self.bottomButton setTitle:@"重新认证" forState:UIControlStateNormal];
        }
    }else{
        self.tableBottomLay.constant = 0;
        self.title = @"购房资格";
    }
}

- (void)setIsSubmit:(BOOL)isSubmit{
    _isSubmit = isSubmit;
    if (_isSubmit) {
        self.title = @"核对并提交信息";
        self.topContent.constant = 48;
        self.tableBottomLay.constant = 70;
        [self.bottomButton setTitle:@"确认提交" forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isReal) {
        return 1;
    }
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isReal) {
        return _nameArray.count;
    }
    NSDictionary *tempDic = _dataArray[section];
    NSInteger count = 0;
    NSString *headerStr = [NSString stringWithFormat:@"%@",tempDic[@"header"]];
    NSString *titleStr = [NSString stringWithFormat:@"%@",tempDic[@"title"]];
    if ([headerStr isEqual:@"申请人信息"]||[headerStr isEqual:@"配偶信息"]) {
        count = 7;
    }else if ([headerStr isEqual:@"子女信息"]) {
        count = 6*[tempDic[@"array"] count];
    }else{
//        if ([headerStr isEqual:@"附加信息"])
        if ([titleStr isEqual:@"特殊人才资料"]) {
            count = 4*[tempDic[@"array"] count]  +1;
        }else if ([titleStr isEqual:@"征收家庭资料"]) {
            count = 2*[tempDic[@"array"] count]  +1;
        }else if ([titleStr isEqual:@"省直机关社保"]) {
            count = 3*[tempDic[@"array"] count]  +1;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.realData) {
        NSDictionary *tempDic = _nameArray[indexPath.row];
        if ([tempDic[@"image"] isKindOfClass:[NSArray class]] ) {//图片
            NSArray *tempImage = @[self.realData[@"sfzzm"],self.realData[@"sfzfm"]];
            NSInteger  count = ceilf(tempImage.count/2.0);
            if (count>0) {
                
                ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
                cell.imageArray = tempImage;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }else if (tempDic[@"title"] != nil) {
            ResultContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultContentTableViewCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = tempDic[@"title"];
            switch (indexPath.row) {
                case 0:
                    cell.contentTextField.text = self.realData[@"xb"];
                    break;
                case 1:
                    cell.contentTextField.text = self.realData[@"mz"];
                    break;
                case 2:
                    cell.contentTextField.text = self.realData[@"csrq"];
                    break;
                case 3:
                    cell.contentTextField.text = self.realData[@"zjhm"];
                    break;
                case 4:
                    cell.contentTextField.text = self.realData[@"qfjg"];
                    break;
                case 5:
                    cell.contentTextField.text = self.realData[@"yxq"];
                    break;
                    
                default:
                    break;
            }
            
            //        cell.contentTextField.text = tempDic[@"content"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{//NSDictionary *temp = @{@"header":@"附加信息",@"array":tsrcList,@"title":@"特殊人才资料"};
        NSDictionary *tempDic = _dataArray[indexPath.section];
        
        NSString *titleStr = [NSString stringWithFormat:@"%@",tempDic[@"title"]];
        NSString *headerStr = [NSString stringWithFormat:@"%@",tempDic[@"header"]];
        if ([headerStr isEqual:@"申请人信息"]||[headerStr isEqual:@"配偶信息"]) {
            PersonModel *model = [tempDic[@"array"] firstObject];
            
            if (indexPath.row == 6) {
                NSDictionary *tempzzxx = [model.zzxx mj_keyValues];
                NSMutableArray *tempArray = [NSMutableArray new];
                for (NSString *strValue in tempzzxx.allValues) {
                    if (strValue.length>ImagePathMin) {
                        [tempArray addObject:strValue];
                    }
                }
                ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
                cell.imageArray = tempArray;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            ResultContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultContentTableViewCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = _nameArray[0][indexPath.row][@"title"];
            switch (indexPath.row) {
                case 0:
                    cell.contentTextField.text = model.jtcy.xm;
                    break;
                case 1:
                    cell.contentTextField.text = model.jtcy.zjhm;
                    break;
                case 2:
                    cell.contentTextField.text = model.jtcy.xb;
                    break;
                case 3:
                    cell.contentTextField.text = model.jtcy.hjfl;
                    break;
                case 4:
                    cell.contentTextField.text = model.jtcy.hyzk;
                    break;
                case 5:
                    cell.contentTextField.text = model.jtcy.hjszd;
                    break;
                    
                default:
                    break;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if ([headerStr isEqual:@"子女信息"]) {
            
            NSInteger itemCount = 6;
            NSInteger customRow = floorf(indexPath.row/6.0);
            NSInteger remainder = (indexPath.row)%itemCount;
            PersonModel *model = tempDic[@"array"][customRow];
            
            if (remainder == itemCount-1) {
                NSDictionary *tempzzxx = [model.zzxx mj_keyValues];
                NSMutableArray *tempArray = [NSMutableArray new];
                for (NSString *strValue in tempzzxx.allValues) {
                    if (strValue.length>ImagePathMin) {
                        [tempArray addObject:strValue];
                    }
                }
                ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
                cell.imageArray = tempArray;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (remainder == 0) {
                
                ResultTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTitleTableViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = model.jtcy.xm;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
            ResultContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultContentTableViewCell" forIndexPath:indexPath];
            
            cell.titleLabel.text = _nameArray[1][remainder][@"title"];
            switch (indexPath.row) {
                case 1:
                    cell.contentTextField.text = model.jtcy.xb;
                    break;
                case 2:
                    cell.contentTextField.text = model.jtcy.hjfl;
                    break;
                case 3:
                    cell.contentTextField.text = model.jtcy.hjszd;
                    break;
                case 4:
                    cell.contentTextField.text = model.jtcy.zjhm;
                    break;
                default:
                    break;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {//if ([headerStr isEqual:@"附加信息"])
            if ([titleStr isEqual:@"特殊人才资料"]) {
                if (indexPath.row == 0) {
                    ResultTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTitleTableViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = titleStr;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
                NSInteger customRow = floorf((indexPath.row-1)/4.0);
                NSInteger remainder = (indexPath.row-1)%4;
                AddOtherModel *model = tempDic[@"array"][customRow];
                
                if (remainder == 3) {
                    NSDictionary *tempzzxx = [model mj_keyValues];
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (NSString *strValue in tempzzxx.allValues) {
                        if (strValue.length>ImagePathMin) {
                            [tempArray addObject:strValue];
                        }
                    }
                    ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
                    cell.imageArray = tempArray;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
                ResultContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultContentTableViewCell" forIndexPath:indexPath];
                
                cell.titleLabel.text = _nameArray[2][remainder][@"title"];
                switch (indexPath.row) {
                    case 1:
                        cell.contentTextField.text = model.tsrclx;
                        break;
                    case 2:
                        cell.contentTextField.text = model.xm;
                        break;
                    case 3:
                        cell.contentTextField.text = model.zcgzlssc;
                        break;
                    default:
                        break;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if ([titleStr isEqual:@"征收家庭资料"]) {
                if (indexPath.row == 0) {
                    ResultTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTitleTableViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = titleStr;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
                NSInteger customRow = floorf((indexPath.row-1)/2.0);
                NSInteger remainder = (indexPath.row-1)%2;
                AddOtherModel *model = tempDic[@"array"][customRow];
                
                if (remainder == 1) {
                    NSDictionary *tempzzxx = [model mj_keyValues];
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (NSString *strValue in tempzzxx.allValues) {
                        if (strValue.length>ImagePathMin) {
                            [tempArray addObject:strValue];
                        }
                    }
                    ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
                    cell.imageArray = tempArray;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
                ResultContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultContentTableViewCell" forIndexPath:indexPath];
                
                cell.titleLabel.text = _nameArray[3][remainder][@"title"];
                cell.contentTextField.text = model.zsbasj;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if ([titleStr isEqual:@"省直机关社保"]) {
                if (indexPath.row == 0) {
                    ResultTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTitleTableViewCell" forIndexPath:indexPath];
                    cell.titleLabel.text = titleStr;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
                NSInteger customRow = floorf((indexPath.row-1)/3.0);
                NSInteger remainder = (indexPath.row-1)%3;
                AddOtherModel *model = tempDic[@"array"][customRow];
                
                if (remainder == 2) {
                    NSDictionary *tempzzxx = [model mj_keyValues];
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (NSString *strValue in tempzzxx.allValues) {
                        if (strValue.length>ImagePathMin) {
                            [tempArray addObject:strValue];
                        }
                    }
                    ResultImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultImageTableViewCell" forIndexPath:indexPath];
                    cell.imageArray = tempArray;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
                ResultContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultContentTableViewCell" forIndexPath:indexPath];
                
                cell.titleLabel.text = _nameArray[3][remainder][@"title"];
                switch (indexPath.row) {
                    case 1:
                        cell.contentTextField.text = model.xm;
                        break;
                    case 2:
                        cell.contentTextField.text = model.szsb;
                        break;
                    default:
                        break;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
   
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.realData) {
        NSDictionary *tempDic = _nameArray[indexPath.row];
        if ([tempDic[@"image"] isKindOfClass:[NSArray class]] ) {//图片
            NSArray *tempImage = tempDic[@"image"];
            NSInteger  count = ceilf(tempImage.count/2.0);
            if (count>0) {
                return 23+3+(108 +12)*CustomScreenFit*count;
            }
        }else if (tempDic[@"title"] != nil) {
            return 51;
        }
    }else{//NSDictionary *temp = @{@"header":@"附加信息",@"array":tsrcList,@"title":@"特殊人才资料"};
        NSDictionary *tempDic = _dataArray[indexPath.section];
        id tempModel = [tempDic[@"array"] firstObject];
        
        NSString *headerStr = [NSString stringWithFormat:@"%@",tempDic[@"header"]];
        if ([headerStr isEqual:@"申请人信息"]||[headerStr isEqual:@"配偶信息"]) {
            PersonModel *model = tempModel;
            
            if (indexPath.row == 6) {
                NSDictionary *tempzzxx = [model.zzxx mj_keyValues];
                NSMutableArray *tempArray = [NSMutableArray new];
                for (NSString *strValue in tempzzxx.allValues) {
                    if (strValue.length>ImagePathMin) {
                        [tempArray addObject:strValue];
                    }
                }

                NSInteger  count = ceilf(tempArray.count/2.0);
                if (count>0) {
                    return 23+3+(108 +12)*CustomScreenFit*count;
                }
            }
            return 51;
        }else if ([headerStr isEqual:@"子女信息"]) {
            NSInteger customRow = floorf(indexPath.row/6.0);
            NSInteger remainder = (indexPath.row)%6;
            PersonModel *model = tempDic[@"array"][customRow];
            
            if (remainder == 5) {
                NSDictionary *tempzzxx = [model.zzxx mj_keyValues];
                NSMutableArray *tempArray = [NSMutableArray new];
                for (NSString *strValue in tempzzxx.allValues) {
                    if (strValue.length>ImagePathMin) {
                        [tempArray addObject:strValue];
                    }
                }
                
                NSInteger  count = ceilf(tempArray.count/2.0);
                if (count>0) {
                    return 23+3+(108 +12)*CustomScreenFit*count;
                }
            }else if (remainder == 0) {}
            return 51;
        }else {// if ([headerStr isEqual:@"附加信息"])
            if (indexPath.row == 0) {return 51;}
            
            
            NSString *titleStr = [NSString stringWithFormat:@"%@",tempDic[@"title"]];
            
            if ([titleStr isEqual:@"特殊人才资料"]) {
                NSInteger customRow = floorf((indexPath.row-1)/4.0);
                NSInteger remainder = (indexPath.row-1)%4;
                AddOtherModel *model = tempDic[@"array"][customRow];
                
                if (remainder == 3) {
                    NSDictionary *tempzzxx = [model mj_keyValues];
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (NSString *strValue in tempzzxx.allValues) {
                        if (strValue.length>ImagePathMin) {
                            [tempArray addObject:strValue];
                        }
                    }
                    
                    NSInteger  count = ceilf(tempArray.count/2.0);
                    if (count>0) {
                        return 23+3+(108 +12)*CustomScreenFit*count;
                    }
                }
                return 51;
            }else if ([titleStr isEqual:@"征收家庭资料"]) {
                NSInteger customRow = floorf((indexPath.row-1)/2.0);
                NSInteger remainder = (indexPath.row -1)%2;
                PersonModel *model = tempDic[@"array"][customRow];
                
                if (remainder == 1) {
                    NSDictionary *tempzzxx = [model mj_keyValues];
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (NSString *strValue in tempzzxx.allValues) {
                        if (strValue.length>ImagePathMin) {
                            [tempArray addObject:strValue];
                        }
                    }
                    
                    NSInteger  count = ceilf(tempArray.count/2.0);
                    if (count>0) {
                        return 23+3+(108 +12)*CustomScreenFit*count;
                    }
                }
                return 51;
            }else if ([titleStr isEqual:@"省直机关社保"]) {
                NSInteger customRow = floorf((indexPath.row-1)/3.0);
                NSInteger remainder = (indexPath.row-1)%3;
                PersonModel *model = tempDic[@"array"][customRow];
                
                if (remainder == 2) {
                    NSDictionary *tempzzxx = [model mj_keyValues];
                    NSMutableArray *tempArray = [NSMutableArray new];
                    for (NSString *strValue in tempzzxx.allValues) {
                        if (strValue.length>ImagePathMin) {
                            [tempArray addObject:strValue];
                        }
                    }
                    
                    NSInteger  count = ceilf(tempArray.count/2.0);
                    if (count>0) {
                        return 23+3+(108 +12)*CustomScreenFit*count;
                    }
                }
                return 51;
            }
        }
        
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section>3) {
        return 0.01;
    }
    return 46;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    ResultQualityHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ResultQualityHeader"];
//    header.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    if (section == 0) {
        header.headerImageView.hidden = NO;
        header.headerLabel.text = @"申请人信息";
    }else{
        header.headerImageView.hidden = YES;
        if (section == 1) {
            header.headerLabel.text = @"配偶信息";
        }else if (section == 2) {
            header.headerLabel.text = @"子女信息";
        }else if (section == 3) {
            header.headerLabel.text = @"附加信息";
        }else{
            return [UIView new];
        }
    }
    if (_isReal) {
        header.headerLabel.text = self.realData[@"xm"];
        if ([[LoginSession sharedInstance].rzzt integerValue] == 3) {
            header.headerImageView.image = [UIImage imageNamed:@"result_3"];
        }else if ([[LoginSession sharedInstance].rzzt integerValue] == 2) {
            header.headerImageView.image = [UIImage imageNamed:@"result_2"];
        }else if ([[LoginSession sharedInstance].rzzt integerValue] == 1) {
            header.headerImageView.image = [UIImage imageNamed:@"result_1"];
        }
    }else{
        if (![Utility is_empty:[LoginSession sharedInstance].grrzzt]) {
            if ([[LoginSession sharedInstance].grrzzt integerValue] == 2) {
                header.headerImageView.image = [UIImage imageNamed:@"result_3"];
            }else if ([[LoginSession sharedInstance].grrzzt integerValue] == 0) {//待审核
                header.headerImageView.image = [UIImage imageNamed:@"result_1"];
            }else if ([[LoginSession sharedInstance].grrzzt integerValue] == 1) {
                header.headerImageView.image = [UIImage imageNamed:@"result_2"];
            }
        }
    }
    return header;
}

#pragma mark - data
///newverifydetail
- (void)reloadData {
    if (_isReal) {
        __weak typeof(self) weakSelf = self;
        [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/newverifydetail") para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
            //banner
            if (success) {
                weakSelf.realData = response[@"data"];
                [weakSelf.tableview reloadData];
            }else{
                [weakSelf alertWithMsg:kFailedTips handler:nil];
            }
        }];
    }else{
        __weak typeof(self) weakSelf = self;
        [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/allmessage/new") para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
 
            if (success) {
                NSDictionary *allDic = response[@"data"];
                
                weakSelf.dataArray = [self modelForDic:allDic];
                
                [weakSelf.tableview reloadData];
            }else{
                [weakSelf alertWithMsg:kFailedTips handler:nil];
            }
        }];
    }
}

- (NSMutableArray *)modelForDic:(NSDictionary *)allDic{
    NSMutableArray *allArray = [NSMutableArray new];
    PersonModel *tempgrxx = [PersonModel mj_objectWithKeyValues:allDic[@"grxx"]];
    if (tempgrxx) {
        NSDictionary *temp = @{@"header":@"申请人信息",@"array":@[tempgrxx]};
        [allArray addObject:temp];
    }
    PersonModel *temppoxx = [PersonModel mj_objectWithKeyValues:allDic[@"poxx"]];
    if (temppoxx) {
        NSDictionary *temp = @{@"header":@"配偶信息",@"array":@[temppoxx]};
        [allArray addObject:temp];
    }
    NSArray *znxxlist = [PersonModel mj_objectArrayWithKeyValuesArray:allDic[@"znxxlist"]];
    if (temppoxx) {
        NSDictionary *temp = @{@"header":@"子女信息",@"array":znxxlist};
        [allArray addObject:temp];
    }
    
    
    
    NSArray *tsrcList = [AddOtherModel mj_objectArrayWithKeyValuesArray:allDic[@"tsrcList"]];
    temppoxx.titleString = @"特殊人才资料";
    if (tsrcList) {
        NSDictionary *temp = @{@"header":@"附加信息",@"array":tsrcList,@"title":@"特殊人才资料"};
        [allArray addObject:temp];
    }
    AddOtherModel *zsjt = [AddOtherModel mj_objectWithKeyValues:allDic[@"zsjt"]];
    if (zsjt) {
        NSString *str = @"附加信息";
        if (tsrcList) {
            str = @"";
        }
        NSDictionary *temp = @{@"header":str,@"array":@[zsjt],@"title":@"征收家庭资料"};
        [allArray addObject:temp];
    }
    NSArray *szsbList = [AddOtherModel mj_objectArrayWithKeyValuesArray:allDic[@"szsbList"]];
    if (szsbList) {
        NSString *str = @"附加信息";
        if (zsjt||tsrcList) {
            str = @"";
        }
        NSDictionary *temp = @{@"header":str,@"array":szsbList,@"title":@"省直机关社保"};
        [allArray addObject:temp];
    }
    
    return allArray;
}

- (void)dataReset{
    if (_isReal) {
        _nameArray = @[//实名认证用
                       @{@"title":@"性别"},
                       @{@"title":@"民族"},
                       @{@"title":@"出生"},
                       //                   @{@"title":@"住址"},
                       @{@"title":@"身份证号码"},
                       @{@"title":@"签证机关"},
                       @{@"title":@"有效期限"},
                       @{@"image":@[@"http://img.findlawimg.com/info/2019/0610/20190610114035328.jpg",@"http://img.findlawimg.com/info/2019/0610/20190610114035328.jpg"]},
                       //                   @{@"image":@""}
                       ];
    }else{
        _nameArray = @[@[@{@"title":@"姓名"},
                         @{@"title":@"身份证号码"},
                         @{@"title":@"性别"},
                         @{@"title":@"家庭户口类型"},
                         @{@"title":@"婚姻状况"},
                         @{@"title":@"户籍所在地"}
                         ],//申请人信息 配偶信息【0】
                       
                       @[@{@"title":@"姓名"},
                         @{@"title":@"性别"},
                         @{@"title":@"家庭户口类型"},
                         @{@"title":@"户籍所在地"},
                         @{@"title":@"身份证号码"},
                         @{@"title":@""}],//子女信息【1】
                       
                       @[@{@"title":@"特殊人才资料"},
                         @{@"title":@"人才类型"},
                         @{@"title":@"姓名"},
                         @{@"title":@"工资流水月数"},@{@"title":@""}],//特殊人才【2】
                       
                       @[@{@"title":@"征收家庭资料"},
                         @{@"title":@"征收备案时间"},@{@"title":@""}],//征收家庭资料【3】
                       
                       @[@{@"title":@"省直机关社保"},
                         @{@"title":@"姓名"},
                         @{@"title":@"缴纳时长"},@{@"title":@""}],//省直机关社保【4】
                       ];
    }
}
//图片

#pragma mark - other
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section>2) {
        return 0.01;
    }
    return 10.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    line.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    return  line;
}

- (IBAction)bottomClick:(id)sender {
    if (_isReal) {
        RealFirstTipViewController *vc = [RealFirstTipViewController new];
        vc.title = @"关于实名认证";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
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
    __weak typeof(self) weakSelf = self;
    self.dataArray = [NSMutableArray new];
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/submitgfsq") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            
//            weakSelf.dataDic = response[@"data"];
//            [weakSelf.tableView reloadData];
//            if (weakSelf.dataDic.count == 0) {
//                [weakSelf addNoneDataTipView];
//            }
            ///  去网络提交 再弹出
            weakSelf.tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
            weakSelf.tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.tipView1];
            weakSelf.tipView1.sureType = 1;
            
            [weakSelf.tipView1.sureButton addTarget:self action:@selector(backRootVC) forControlEvents:UIControlEventTouchUpInside];
            //
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
    
    
}

- (void)backRootVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
