//
//  ChooseMySelfAndRealViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseMySelfAndRealViewController.h"
#import "AddMateShipHeaderView.h"
#import "AddMateShipFooterView.h"
#import "AddMateShipTableViewCell.h"
#import "PureCamera.h"
#import "JYBDIDCardVC.h"
#import "ChooseQualificationTypeViewController.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "MOFSPickerManager.h"
#import "RealFirstTipViewController.h"

@interface ChooseMySelfAndRealViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AddMateShipHeaderView *header;
@property (strong, nonatomic) AddMateShipFooterView *footer;

@property (strong, nonatomic) NSArray *imageStrArray;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *firstArray;
@property (strong, nonatomic) NSMutableArray *secondArray;

@property (nonatomic , assign) NSInteger tagSwitch;
@property (nonatomic , strong) ReleaseHomeworkTimeViewMask *timeViewMask;

@property (nonatomic , strong) RealFinishTipView1 *tipView1;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;
@end

@implementation ChooseMySelfAndRealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加申购人信息";
    _firstArray = [NSMutableArray new];
    
    _secondArray = @[@{@"title":@"家庭户口类型",@"content":@""},
                     @{@"title":@"户籍所在地",@"content":@""},
                     @{@"title":@"婚姻状况",@"content":@""}].mutableCopy;
    _dataArray = @[self.firstArray,//身份证扫出来
                   _secondArray
                   ];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMateShipTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"AddMateShipTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.selec = UITableViewCellSelectionStyleNone;
    [self.tableView reloadData];
    
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"AddMateShipHeaderView" owner:nil options:nil] lastObject];
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"AddMateShipFooterView" owner:nil options:nil] lastObject];
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320-64 -116);
    self.footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
    self.footer.addimageTwo.hidden = YES;
    self.footer.addButtonTwo.hidden = YES;
    [self.footer.addButtonOne setTitle:@"请上传本人户口页" forState:UIControlStateNormal];
    [self.header.addButtonOne setTitle:@"点击扫描本人身份证正面" forState:UIControlStateNormal];
    [self.header.addButtonTwo setTitle:@"点击扫描本人身份证反面" forState:UIControlStateNormal];
    
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

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}

- (void)changeIdClick {
    
    __weak __typeof__(self) weakSelf = self;
    
    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.isBehinded = NO;
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {
        weakSelf.secondArray = [weakSelf.dataArray lastObject];
        NSArray *tempArray = @[@{@"title":@"姓名",@"content":info.name},
                               @{@"title":@"性别",@"content":info.gender},
                               @{@"title":@"民族",@"content":info.nation},
                               @{@"title":@"出生日期",@"content":[info.num substringWithRange:NSMakeRange(6, 8)]},
                               @{@"title":@"住址",@"content":info.address},
                               @{@"title":@"身份证号码",@"content":info.num}];
        [weakSelf.firstArray addObjectsFromArray:tempArray];
        weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                               @[weakSelf.secondArray[0],
                                 weakSelf.secondArray[1],
                                 weakSelf.secondArray[2]]
                               ];
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
        weakSelf.secondArray = [weakSelf.dataArray lastObject];
        NSArray *tempArray = @[@{@"title":@"签发机关",@"content":info.issue},
                               @{@"title":@"有效期限",@"content":info.valid},
                               ];
        [weakSelf.firstArray addObjectsFromArray:tempArray];
        weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                               @[weakSelf.secondArray[0],
                                 weakSelf.secondArray[1],
                                 weakSelf.secondArray[2]]
                               ];
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
    
    if (1) {
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
            [SVProgressHelper dismissWithMsg:@"请完善申购人信息"];
            return;
        }
    }
    if (self.header.addImageViewOne.image&&
        self.header.addImageViewTwo.image&&
        self.footer.addImageOne.image&&

        self.dataArray.count>=2
        ) {
        _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
        _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
        _tipView1.sureType = 0;
        
        for (NSDictionary *tempDic in [_dataArray firstObject]) {
            if ([tempDic[@"title"] isEqualToString:@"姓名"]) {
                _tipView1.textField1.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"性别"]) {
                _tipView1.textField2.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"民族"]) {
                _tipView1.textField3.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"出生日期"]) {
                _tipView1.textField4.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"住址"]) {
                _tipView1.textField5.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"身份证号码"]) {
                _tipView1.textField6.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"签发机关"]) {
                _tipView1.textField7.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }else if ([tempDic[@"title"] isEqualToString:@"有效期限"]) {
                _tipView1.textField8.text = [NSString stringWithFormat:@"%@",tempDic[@"content"]];
            }
        }
        
        [self startCount];
        _tipView1.sureButton.userInteractionEnabled = NO;
        [_tipView1.sureButton addTarget:self action:@selector(beginUpLoad) forControlEvents:UIControlEventTouchUpInside];
        
//        [self updateLoadImage:nil];
    }else{
        [SVProgressHelper dismissWithMsg:@"请完善申购人信息"];
    }
}
- (void)startCount {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didOneSecReached:) userInfo:nil repeats:YES];
    self.count = 3;
    
    [_tipView1.sureButton setTitle:@"3s后可提交" forState:UIControlStateNormal];
    _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
}
- (void)beginUpLoad{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self updateLoadImage:nil];
}

- (void)didOneSecReached:(id)sender {
    
    if (self.count > 0) {
        self.count--;
        NSString *countStr = [NSString stringWithFormat:@"%lds后可提交",self.count];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateNormal];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateSelected];
        _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
        if (self.count == 0) {
            
            _tipView1.sureButton.userInteractionEnabled = YES;
            [_tipView1.sureButton setTitle:@"确认提交" forState:UIControlStateNormal];
            [_tipView1.sureButton setTitle:@"确认提交" forState:UIControlStateSelected];
            _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xC0905D);
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}


- (void)updateLoadImage:(UIImage *)upImage{
    __weak typeof(self) weakSelf = self;
    NSArray *imageArray = @[self.header.addImageViewOne.image,self.header.addImageViewTwo.image
                            ,self.footer.addImageOne.image
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
        if ([tempDic[@"title"] isEqualToString:@"婚姻状况"]) {
            [pramDic setObject:[NSString stringWithFormat:@"%@",tempDic[@"content"]] forKey:@"hyzk"];
        }
    }
    
    [pramDic setObject:@"身份证" forKey:@"zjlx"];
    
//    [pramDic setObject:[LoginSession sharedInstance].otherYhbh forKey:@"yhbh"];
    [pramDic setObject:self.imageStrArray[0] forKey:@"sfzzm"];
    [pramDic setObject:self.imageStrArray[1] forKey:@"sfzfm"];
    [pramDic setObject:self.imageStrArray[2] forKey:@"hkb"];
//    [pramDic setObject:self.imageStrArray[3] forKey:@"jhz"];
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savehost") para:pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        if (success) {
            [LoginSession sharedInstance].rzzt = @"1";
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
     _tagSwitch = button.tag;
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
            
            weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                                   @[tempArr.firstObject,
                                     @{@"title":@"户籍所在地",@"content":address},
                                     tempArr.lastObject]
                                   ];
            [self.tableView reloadData];
            NSLog(@"%@", zipcode);
            
        } cancelBlock:^{
            
        }];
    }else if (button.tag == 2) {
        
        [self showOtherAlertView:@[@"已婚",@"未婚",@"离异",@"丧偶"]];
    }else{
        _timeViewMask.titleLabel.text = @"请选择家庭户口类型";
        [self showOtherAlertView:@[@"集体户口",@"家庭户口"]];
    }
}
- (void)showOtherAlertView:(NSArray *)array{
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:_timeViewMask];
    _timeViewMask.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _timeViewMask.customPickArray = array;
    if (array.count == 2) {
        _timeViewMask.titleLabel.text = @"请选择家庭户口类型";
    }else{
        _timeViewMask.titleLabel.text = @"请选择婚姻状况";
    }
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)timecancleButtonClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
}
- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    
    switch (_tagSwitch) {
        case 0:{//地区
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[self.dataArray lastObject]];
            NSDictionary *temp1 = tempArr[1];
            self.dataArray = @[self.firstArray,//身份证扫出来
                               @[@{@"title":@"家庭户口类型",@"content":_timeViewMask.selectedString},
                                 temp1,
                                 tempArr.lastObject]
                               ];
            [self.tableView reloadData];
        }break;
        case 2:{//性别
            NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:[self.dataArray lastObject]];
            NSDictionary *temp1 = tempArr[1];
            self.dataArray = @[self.firstArray,//身份证扫出来
                               @[tempArr.firstObject,
                                 temp1,
                                 @{@"title":@"婚姻状况",@"content":_timeViewMask.selectedString}]
                               ];
            [self.tableView reloadData];
            
        }break;
            
        default:
            break;
    }
    
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


- (IBAction)realClick:(id)sender {
    RealFirstTipViewController *vc = [RealFirstTipViewController new];
    vc.title = @"关于实名认证";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
