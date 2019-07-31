//
//  RecognitionListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RecognitionListViewController.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "RecogtionHousesCollectionViewCell.h"
#import "HouseListModel.h"
#import "HouseDetialViewController.h"

@interface RecognitionListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;



/** 倒计时 */
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) RealFinishTipView1 *tipView1;

/** 当前page */
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSArray *houses;

@property (nonatomic , strong) HouseListModel *tempModel;
@end

@implementation RecognitionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"楼盘认筹";
    self.view.backgroundColor = kListBgColor;
    [self viewInit];
    
    
    UIImage *rightImage = [[UIImage imageNamed:@"recognitionList_tip"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(rightTipClick)];
}

- (void)viewInit {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = kListBgColor;
    [self.view addSubview:self.contentCollectionView];
    
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"RecogtionHousesCollectionViewCell" bundle:[NSBundle bundleForClass:[RecogtionHousesCollectionViewCell class]]] forCellWithReuseIdentifier:@"RecogtionHousesCollectionViewCell"];
    
    __weak typeof (self) weakSelf = self;
    self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.contentCollectionView.mj_footer resetNoMoreData];
        [weakSelf reloadData];
    }];
    self.contentCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf reloadData];
    }];
}



#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  _houses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecogtionHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecogtionHousesCollectionViewCell" forIndexPath:indexPath];
    cell.model = _houses[indexPath.row];
    cell.recogtionButton.tag = indexPath.row;
    [cell.recogtionButton addTarget:self action:@selector(recogtionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH-10)/2, 120*CustomScreenFit+122);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    HouseListModel *model = self.houses[indexPath.row];
    vc.strBH = model.saleid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)recogtionButtonClick:(UIButton *)button{
    _tempModel = _houses[button.tag];
    //确定认筹/
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    _tipView1.contentTitleLabel.font = kSysFont(13);
    _tipView1.contentTitleLabel.text = @"\n是否确定认购该项目？认购成功后，不能同时再认购其他项目。\n\n认购限制解除规则：项目摇号名单确认后，未进入摇号名单，2个工作日解除。如进入摇号名单，选房结束后解除。";
    _tipView1.titleLabel.text = _tempModel.lpmc;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_tipView1.contentTitleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3; // 调整行间距

    NSRange range2 = [_tipView1.contentTitleLabel.text rangeOfString:@"是否确定认购该项目？认购成功后，不能同时再认购其他项目。"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_tipView1.contentTitleLabel.text length])];
    [_tipView1.contentTitleLabel setAttributedText:attributedString];
    
    _tipView1.contentTitleLabel.textAlignment = NSTextAlignmentLeft;
    _tipView1.titleLabel.textAlignment = NSTextAlignmentCenter;
 
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"3s后可确认" forState:UIControlStateNormal];
    
    [self startCount];
    _tipView1.sureButton.userInteractionEnabled = NO;
    [_tipView1.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
}



- (void)startCount {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didOneSecReached:) userInfo:nil repeats:YES];
    self.count = 3;
    
    [_tipView1.sureButton setTitle:@"3s后可确认" forState:UIControlStateNormal];
    _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
}
- (void)didOneSecReached:(id)sender {
    
    if (self.count > 0) {
        self.count--;
        NSString *countStr = [NSString stringWithFormat:@"%lds后可确认",self.count];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateNormal];
        [_tipView1.sureButton setTitle:countStr forState:UIControlStateSelected];
        _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xcbc2b9);
        if (self.count == 0) {
            
            _tipView1.sureButton.userInteractionEnabled = YES;
            [_tipView1.sureButton setTitle:@"确认" forState:UIControlStateNormal];
            [_tipView1.sureButton setTitle:@"确认" forState:UIControlStateSelected];
            _tipView1.sureButton.backgroundColor = kUIColorFromRGB(0xC0905D);
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)sureButtonClick{//提交
    
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/renchou") para: @{@"lpbh":[NSString stringWithFormat:@"%@",_tempModel.lpbh],@"saleid":[NSString stringWithFormat:@"%@",_tempModel.saleid]} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        if (success) {
            
            [SVProgressHelper dismissWithMsg:response[@"msg"]];
        }else{
            [weakSelf alertWithMsg:kFailedTips handler:nil];
        }
    }];
}

- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/renchoulist") para: @{@"page":@"1",@"rows":@"999"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            
            weakSelf.houses = [HouseListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.contentCollectionView reloadData];
            if (weakSelf.houses.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
        }
        [weakSelf.contentCollectionView.mj_header endRefreshing];
        [weakSelf.contentCollectionView.mj_footer endRefreshing];
        //            [weakSelf.contentCollectionView.mj_header endRefreshing];
        //            [weakSelf.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}



- (void)rightTipClick{
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 2;
    
    _tipView1.contentTitleLabel.font = kSysFont(13);
    _tipView1.contentTitleLabel.text = @"\n1、部分楼盘认筹需验资或其他线下补充资料，该类楼盘暂时不支持线上认筹，如有需要请至线下认筹。\n2、认筹成功后，在该认筹未解除前，您暂时无法认筹其他项目。\n3、认筹解除规则：项目摇号名单确认后，未进入摇号名单，则2个工作日内解除认筹，如进入摇号名单，则选房结束后解除认筹。";
    _tipView1.titleLabel.text = @"认筹说明";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_tipView1.contentTitleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3; // 调整行间距
    NSRange range = NSMakeRange(0, [_tipView1.contentTitleLabel.text length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [_tipView1.contentTitleLabel setAttributedText:attributedString];
    
    _tipView1.contentTitleLabel.textAlignment = NSTextAlignmentLeft;
    _tipView1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_tipView1.sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
}
@end
