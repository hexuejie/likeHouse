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

@interface ChooseAddMateshipViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AddMateShipHeaderView *header;
@property (strong, nonatomic) AddMateShipFooterView *footer;

@property (strong, nonatomic) NSString *imageStr1;
@property (strong, nonatomic) NSString *imageStr2;
@property (strong, nonatomic) NSString *imageStr3;
@property (strong, nonatomic) NSString *imageStr4;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *firstArray;

@end

@implementation ChooseAddMateshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加配偶信息";
    _firstArray = [NSMutableArray new];
    _dataArray = @[self.firstArray,//身份证扫出来
                     @[@{@"title":@"家庭户口类型",@"content":@""},
                       @{@"title":@"户籍所在地",@"content":@""},
                       @{@"title":@"手机号码",@"content":@""}]
                     ];
    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMateShipFooterView class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"AddMateShipFooterView"];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMateShipHeaderView class])  bundle:nil] forHeaderFooterViewReuseIdentifier:@"AddMateShipHeaderView"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddMateShipTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"AddMateShipTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.selec = UITableViewCellSelectionStyleNone;
    [self.tableView reloadData];
    
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"AddMateShipHeaderView" owner:nil options:nil] lastObject];
    self.footer = [[[NSBundle mainBundle] loadNibNamed:@"AddMateShipFooterView" owner:nil options:nil] lastObject];
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320-64);
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
                               @{@"title":@"出生",@"content":[info.num substringWithRange:NSMakeRange(6, 8)]},
                               @{@"title":@"住址",@"content":info.address},
                               @{@"title":@"身份证号码",@"content":info.num}];
        [weakSelf.firstArray addObjectsFromArray:tempArray];
        weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                       @[@{@"title":@"家庭户口类型",@"content":@""},
                         @{@"title":@"户籍所在地",@"content":@""},
                         @{@"title":@"手机号码",@"content":@""}]
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
        NSArray *tempArray = @[@{@"title":@"签证机关",@"content":info.issue},
                               @{@"title":@"有效期限",@"content":info.valid},
                               ];
        [weakSelf.firstArray addObjectsFromArray:tempArray];
        weakSelf.dataArray = @[weakSelf.firstArray,//身份证扫出来
                               @[@{@"title":@"家庭户口类型",@"content":@""},
                                 @{@"title":@"户籍所在地",@"content":@""},
                                 @{@"title":@"手机号码",@"content":@""}]
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
    cell.contentTextField.text = rowDic[@"content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    [NetWork uploadMoreFileHttpRequestURL:DetailUrlString(@"/upload") RequestPram:nil arrayImg:imageArray arrayAudio:nil RequestSuccess:^(id  _Nonnull respoes) {
        if (respoes) {
            [weakSelf updatePersonData];
        }
    } RequestFaile:^(NSError * _Nonnull erro) {
        [weakSelf alertWithMsg:@"上传图片出错" handler:nil];
    } UploadProgress:nil];
}

- (void)updatePersonData{
    if (![LoginSession sharedInstance].yhbh) {
        [LoginSession sharedInstance].yhbh = @"";
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *pram = @{
//,@"csrq"    19941024
//,@"hjfl"    家庭户口
//,@"hjszd"    北京市-北京市-东城区
//,@"hkb"    /2019/06/21/156110321053218976229976010302372140.png
//,@"jhz"    /2019/06/21/156110321061240120529976010382791476.png
//,@"lxdh"    15116171468
//,@"mz"    汉
//,@"qfjg"    桃源县公安局
//,@"sfzfm"    /2019/06/21/156110321047293170329976010242479766.png
//,@"sfzzm"    /2019/06/21/156110321043343136029976010203615300.png
//,@"token"    eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ5aHp0IjowLCJyenJxIjoiMjAxOC0wOS0wMiIsInpqbHgiOiLouqvku73or4EiLCJyenp0IjoyLCJzamhtIjoiMTUxMTYxNjQ2OTAiLCJ5aHhtIjoi5p2o5piOIiwiempobSI6IjQzMDEyMjE5ODkxMDEwMjE5NyIsImV4cCI6MTU1OTczNTI1NiwieWhiaCI6IkEwMDAxMjAyNjkifQ.5JM30YRJSpCScdGypeaLFK6kYc0jREldxvI96F2lUK0
//,@"xb"    女
//,@"xm"    蔡怡君
//,@"yxq"    20140413-20240413
//,@"zjhm"    431026199410241639
//,@"zjlx"    身份证
//,@"zz"    湖南省桃源县九溪乡墟场
                           };

    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/savepo/new") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
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
//            if (![Utility is_empty:tempgrxx[@"jtcy"][@"hjszd"]]) {//地址
//                self.threeTextField.text = tempgrxx[@"jtcy"][@"hjszd"];
//            }
//            if (![Utility is_empty:tempgrxx[@"zzxx"][@"hkb"]]) {//图片
//                [self.addImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,tempgrxx[@"zzxx"][@"hkb"]]]];
//            }
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardChange:(NSNotification *)note{
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyHeight =  [UIScreen mainScreen].bounds.size.height - frame.origin.y;
    self.view.frame = CGRectMake(0, -keyHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
