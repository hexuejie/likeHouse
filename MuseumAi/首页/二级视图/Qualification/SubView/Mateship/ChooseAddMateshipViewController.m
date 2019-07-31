//
//  ChooseAddMateshipViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseAddMateshipViewController.h"
#import "AddMateShipHeaderView.h"
#import "AddMateShipFooterView.h"
#import "AddMateShipTableViewCell.h"
#import "PureCamera.h"
#import "JYBDIDCardVC.h"
#import "ChooseQualificationTypeViewController.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "MOFSPickerManager.h"

@interface ChooseAddMateshipViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AddMateShipHeaderView *header;
@property (strong, nonatomic) AddMateShipFooterView *footer;

@property (strong, nonatomic) NSArray *imageStrArray;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) NSMutableArray *secondArray;

@property (strong, nonatomic) NSString *hyzk;

@property (nonatomic , strong) RealFinishTipView1 *tipView1;
@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;
@end

@implementation ChooseAddMateshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"AddMateShipHeaderView" owner:nil options:nil] lastObject];
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"AddMateShipFooterView" owner:nil options:nil] lastObject];
    
    [self initCustomData];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMateShipTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"AddMateShipTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.selec = UITableViewCellSelectionStyleNone;
    [self.tableView reloadData];
    
    
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320-64 -116);
    self.footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    
    [self.header.addButtonOne addTarget:self action:@selector(changeIdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.header.addButtonTwo addTarget:self action:@selector(changeBhindClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footer.addButtonOne addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.footer.addButtonTwo addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    
}
- (void)initCustomData{
    self.title = @"添加配偶信息";
    _firstArray = [NSMutableArray new];
    _secondArray = @[@{@"title":@"家庭户口类型",@"content":@""},
                     @{@"title":@"户籍所在地",@"content":@""},
                     @{@"title":@"手机号码",@"content":@""}].mutableCopy;
    
    NSDictionary *tempDic = [PersonInfo sharedInstance].allmessageDic;
    if (tempDic[@"grxx"][@"jtcy"][@"hyzk"]) {
        if ([tempDic[@"grxx"][@"jtcy"][@"hyzk"] isEqualToString:@"离异"]||[tempDic[@"grxx"][@"jtcy"][@"hyzk"] isEqualToString:@"丧偶"]) {
            _hyzk = tempDic[@"grxx"][@"jtcy"][@"hyzk"];
            [_secondArray addObject:@{@"title":[NSString stringWithFormat:@"%@时间",_hyzk],@"content":@""}];
        }
    }
    
    if (self.personData) {
        
        _firstArray = @[@{@"title":@"姓名",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.xm]},
                               @{@"title":@"性别",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.xb]},
                               @{@"title":@"民族",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.xm]},//
                               @{@"title":@"出生日期",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.qtzjcsrq]},//qrrq
                               @{@"title":@"住址",@"content":[NSString stringWithFormat:@"%@",self.personData.sfz[@"zz"]]},//
                               @{@"title":@"身份证号码",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.zjhm]},
                               
                               @{@"title":@"签发机关",@"content":[NSString stringWithFormat:@"%@",self.personData.sfz[@"qfjg"]]},
                               @{@"title":@"有效期限",@"content":[NSString stringWithFormat:@"%@",self.personData.sfz[@"yxq"]]}
                               ].mutableCopy;
        
        _secondArray = @[@{@"title":@"家庭户口类型",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.hjfl]},
                         @{@"title":@"户籍所在地",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.hjszd]},
                         @{@"title":@"手机号码",@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.lxdh]}].mutableCopy;
        if (_hyzk.length>1) {
             [_secondArray addObject:@{@"title":[NSString stringWithFormat:@"%@时间",_hyzk],@"content":[NSString stringWithFormat:@"%@",self.personData.jtcy.lysj]}];
        }
        
        [self.header.addImageViewOne setCommenImageUrl:self.personData.zzxx.sfzzm];
        [self.header.addImageViewTwo setCommenImageUrl:self.personData.zzxx.sfzfm];
        [self.footer.addImageOne setCommenImageUrl:self.personData.zzxx.hkb];
        [self.footer.addimageTwo setCommenImageUrl:self.personData.zzxx.jhz];
        
        UIButton *_rigthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
        [_rigthButton setTitle:@"删除" forState:UIControlStateNormal];
        [_rigthButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
        [_rigthButton addTarget:self action:@selector(tipView1Clear) forControlEvents:UIControlEventTouchUpInside];
        _rigthButton.titleLabel.font = kSysFont(16);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rigthButton];
    }
    _dataArray = @[self.firstArray,//身份证扫出来
                   _secondArray
                   ];
}

- (void)tipView1Clear{
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _tipView1.contentTitleLabel.text = [NSString stringWithFormat:@"确定删除该信息？"];
    [_tipView1.sureButton addTarget:self action:@selector(tightViewClear) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}

- (void)changeIdClick {
    
    __weak __typeof__(self) weakSelf = self;

    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.isBehinded = NO;
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {
        NSArray *tempArray = @[@{@"title":@"姓名",@"content":info.name},
                               @{@"title":@"性别",@"content":info.gender},
                               @{@"title":@"民族",@"content":info.nation},
                               @{@"title":@"出生日期",@"content":[info.num substringWithRange:NSMakeRange(6, 8)]},
                               @{@"title":@"住址",@"content":info.address},
                               @{@"title":@"身份证号码",@"content":info.num}];
        [weakSelf.firstArray addObjectsFromArray:tempArray];
        weakSelf.secondArray = [weakSelf.dataArray lastObject];
        if (weakSelf.hyzk.length >1) {
            weakSelf.dataArray = @[self.firstArray,//身份证扫出来
                                   @[weakSelf.secondArray[0],
                                     weakSelf.secondArray[1],
                                     weakSelf.secondArray[2],
                                     @{@"title":[NSString stringWithFormat:@"%@时间",weakSelf.hyzk],@"content":@""}]
                                   ];
        }else{
            weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                                   @[weakSelf.secondArray[0],
                                     weakSelf.secondArray[1],
                                     weakSelf.secondArray[2]]
                                   ];
        }
       
        
        weakSelf.header.addImageViewOne.image = image;
        [weakSelf.tableView reloadData];
    };
    [self presentViewController:AVCaptureVC animated:YES completion:nil];
    
}
- (void)changeBhindClick {
    __weak __typeof__(self) weakSelf = self;

    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.isBehinded = YES;
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {
        NSArray *tempArray = @[@{@"title":@"签发机关",@"content":info.issue},
                               @{@"title":@"有效期限",@"content":info.valid},
                               ];
        [weakSelf.firstArray addObjectsFromArray:tempArray];
        weakSelf.secondArray = [weakSelf.dataArray lastObject];
        if (weakSelf.hyzk.length >1) {
            weakSelf.dataArray = @[self.firstArray,//身份证扫出来
                                   @[weakSelf.secondArray[0],
                                     weakSelf.secondArray[1],
                                     weakSelf.secondArray[2],
                                     @{@"title":[NSString stringWithFormat:@"%@时间",weakSelf.hyzk],@"content":@""}]
                                   ];
        }else{
            weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                                   @[weakSelf.secondArray[0],
                                     weakSelf.secondArray[1],
                                     weakSelf.secondArray[2]]
                                   ];
        }
        weakSelf.header.addImageViewTwo.image = image;
        [weakSelf.tableView reloadData];
    };
    [self presentViewController:AVCaptureVC animated:YES completion:nil];
}

- (void)openCamera:(UIButton *)button

{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        PureCamera *homec = [[PureCamera alloc] init];
        __weak typeof(self) myself = self;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                if (button.tag == 101) {
                    myself.footer.addImageOne.image = ss;
                    //                    [self.view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                }else if (button.tag == 102) {
                    myself.footer.addimageTwo.image = ss;
                    //                    myself.exchangeImageTwo.layer.borderColor = [UIColor clearColor].CGColor;
                }
            }
        };
        [myself presentViewController:homec
                             animated:NO
                           completion:^{
                           }];
    } else {
        NSLog(@"相机调用失败");
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddMateShipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMateShipTableViewCell" forIndexPath:indexPath];
    NSDictionary *rowDic = _dataArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = rowDic[@"title"];
    cell.contentTextField.placeholder = [NSString stringWithFormat:@"请输入%@",cell.titleLabel.text];
    cell.clickButton.hidden = YES;
    cell.clickButton.tag = indexPath.row;
    cell.contentTextField.tag = indexPath.section*100+indexPath.row;
    if ([cell.titleLabel.text isEqualToString:@"家庭户口类型"]||[cell.titleLabel.text isEqualToString:@"户籍所在地"]
        ||[cell.titleLabel.text containsString:@"时间"]) {
        cell.contentTextField.placeholder = [NSString stringWithFormat:@"请选择%@",cell.titleLabel.text];
        cell.clickButton.hidden = NO;
        [cell.clickButton addTarget:self action:@selector(clickButtonRow:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.contentTextField.text = rowDic[@"content"];
    cell.contentTextField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    CGFloat fff = textField.tag/100.0;
    NSInteger section = floor(fff);
    NSInteger row = fmod(textField.tag,100);
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textField.text.length) {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:weakSelf.dataArray[section][row]];
            [tempDic setObject:textField.text forKey:@"content"];
            
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:weakSelf.dataArray[section] ];
            [tempArr setObject:tempDic atIndexedSubscript:row];
            
            NSMutableArray *tempAllArr = [[NSMutableArray alloc]initWithArray:weakSelf.dataArray];
            [tempAllArr setObject:tempArr atIndexedSubscript:section];
            weakSelf.dataArray = tempAllArr;
        }

    });
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 51.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0&&[[_dataArray firstObject] count]==0) {
        return 0.01;
    }
    return 10.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * editContentFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    editContentFooterView.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    return editContentFooterView;
}


#pragma mark - Click
- (IBAction)nextStepClick:(id)sender {
    //验证信息
    
    for (NSDictionary *tempDic in [self.dataArray lastObject]) {
        if ([tempDic[@"content"] length] == 0) {
            [SVProgressHelper dismissWithMsg:@"请完善配偶信息"];
            return;
        }
    }
    if (self.header.addImageViewOne.image&&
        self.header.addImageViewTwo.image&&
        self.footer.addImageOne.image&&
        self.footer.addimageTwo.image&&
        self.dataArray.count>=2
        ) {
        [self updateLoadImage:nil];
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善配偶信息"];
    }
}

- (void)updateLoadImage:(UIImage *)upImage{
    __weak typeof(self) weakSelf = self;
    NSArray *imageArray = @[self.header.addImageViewOne.image,self.header.addImageViewTwo.image
                            ,self.footer.addImageOne.image,self.footer.addimageTwo.image
                            ];
    [NetWork uploadMoreFileHttpRequestURL:DetailUrlString(@"/upload") RequestPram:@{} arrayImg:imageArray arrayAudio:@[] RequestSuccess:^(id  _Nonnull respoes) {
        if (respoes) {
            weakSelf.imageStrArray = [respoes componentsSeparatedByString:@";"];
            [weakSelf updatePersonData];
        }
    } RequestFaile:^(NSError * _Nonnull erro) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
    } UploadProgress:nil];
}

- (void)updatePersonData{
    if (![LoginSession sharedInstance].otherYhbh) {
        [LoginSession sharedInstance].otherYhbh = @"";//回填
    }
    NSMutableDictionary *pramDic = [NSMutableDictionary new];
    
    for (NSDictionary *tempDic in [_dataArray firstObject]) {
        
        if ([tempDic[@"title"] isEqualToString:@"出生日期"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"csrq"];
        }
        if ([tempDic[@"title"] isEqualToString:@"住址"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"zz"];
        }
        if ([tempDic[@"title"] isEqualToString:@"身份证号码"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"zjhm"];
        }
        if ([tempDic[@"title"] isEqualToString:@"有效期限"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"yxq"];
        }
        if ([tempDic[@"title"] isEqualToString:@"姓名"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"xm"];
        }
        if ([tempDic[@"title"] isEqualToString:@"性别"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"xb"];
        }
        if ([tempDic[@"title"] isEqualToString:@"民族"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"mz"];
        }
        if ([tempDic[@"title"] isEqualToString:@"签发机关"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"qfjg"];
        }
    }
    for (NSDictionary *tempDic in [_dataArray lastObject]) {
        
        if ([tempDic[@"title"] isEqualToString:@"家庭户口类型"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"hjfl"];
        }
        if ([tempDic[@"title"] isEqualToString:@"户籍所在地"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"hjszd"];
        }
        if ([tempDic[@"title"] isEqualToString:@"手机号码"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"lxdh"];
        }
        if ([tempDic[@"title"] isEqualToString:@"离异时间"]||[tempDic[@"title"] isEqualToString:@"丧偶时间"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"lysj"];
        }
    }
    
    [pramDic setObject:@"身份证" forKey:@"zjlx"];
    
//    [pramDic setObject:[LoginSession sharedInstance].otherYhbh forKey:@"yhbh"];
    [pramDic setObject:self.imageStrArray[0] forKey:@"sfzzm"];
    [pramDic setObject:self.imageStrArray[1] forKey:@"sfzfm"];
    [pramDic setObject:self.imageStrArray[2] forKey:@"hkb"];
    [pramDic setObject:self.imageStrArray[3] forKey:@"jhz"];
    __weak typeof(self) weakSelf = self;
//lysj
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savepo/new") para:pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            [SVProgressHelper dismissWithMsg:response[@"msg"]];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ChooseQualificationTypeViewController class]]) {
                    ChooseQualificationTypeViewController *A =(ChooseQualificationTypeViewController *)controller;
                    [self.navigationController popToViewController:A animated:YES];
                }
            }

        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)reloadData {
    __weak typeof(self) weakSelf = self;

    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/allmessage/new") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            
            weakSelf.dataDic = response[@"data"];
            NSDictionary *tempgrxx = weakSelf.dataDic[@"poxx"];
            [LoginSession sharedInstance].otherYhbh = tempgrxx[@"jtcy"][@"yhbh"];
            if ([LoginSession sharedInstance].otherYhbh == nil) {
                [LoginSession sharedInstance].otherYhbh = @"";
            }
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)clickButtonRow:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    if (button.tag == 1) {
        NSString *string;
        for (NSDictionary *tempDic in [_dataArray lastObject]) {
            
            if ([tempDic[@"title"] isEqualToString:@"户籍所在地"]) {
                string = tempDic[@"content"];
            }
        }
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultAddress:string title:@"请选择户籍所在地" cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[weakSelf.dataArray lastObject]];
            
            if (self.hyzk.length >1) {
                weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                                       @[tempArr.firstObject,
                                         @{@"title":@"户籍所在地",@"content":address},
                                         tempArr[2],
                                         tempArr.lastObject]
                                       ];
                
            }else{
                weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                                       @[tempArr.firstObject,
                                         @{@"title":@"户籍所在地",@"content":address},
                                         tempArr.lastObject]
                                       ];
            }
            
            [self.tableView reloadData];
            NSLog(@"%@", zipcode);
            
        } cancelBlock:^{
            
        }];
    }else if (button.tag == 3) {
        _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] firstObject];
        _timeViewMask.titleLabel.text = [NSString stringWithFormat:@"请选择%@时间",_hyzk];
        [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
        _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
        [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [self showOtherAlertView:@[@"集体户口",@"家庭户口"]];
    }
}
- (void)showOtherAlertView:(NSArray *)array{
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.customPickArray = array;
    
    _timeViewMask.titleLabel.text = @"请选择家庭户口类型";
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)timecancleButtonClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
}
- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    if( [_timeViewMask.titleLabel.text isEqualToString:@"请选择家庭户口类型"]){
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[self.dataArray lastObject]];
         if (self.hyzk.length >1) {
             self.dataArray = @[self.firstArray,//身份证扫出来
                                @[@{@"title":@"家庭户口类型",@"content":_timeViewMask.selectedString},
                                  tempArr[1],
                                  tempArr[2],
                                  tempArr.lastObject]
                                ];
         }else{
             self.dataArray = @[self.firstArray,//身份证扫出来
                                @[@{@"title":@"家庭户口类型",@"content":_timeViewMask.selectedString},
                                  tempArr[1],
                                  tempArr.lastObject]
                                ];
         }
    }else{
        NSDate *select = _timeViewMask.pickBottom.date;
        NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc]init];
        selectDateFormatter.dateFormat = @"yyyy.MM.dd";
        NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[self.dataArray lastObject]];
        self.dataArray = @[self.firstArray,//身份证扫出来
                           @[tempArr[0],
                             tempArr[1],
                             tempArr[2],
                             @{@"title":[NSString stringWithFormat:@"%@时间",_hyzk],@"content":dateAndTime}]
                           ];
    }
    [self.tableView reloadData];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardChange:(NSNotification *)note{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyHeight =  [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    self.view.frame = CGRectMake(0, -keyHeight/2, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)tightViewClear{
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/delpo") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [SVProgressHelper dismissWithMsg:@"删除成功！"];
            [weakSelf callBackClick];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

@end
