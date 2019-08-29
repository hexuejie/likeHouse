//
//  HousesListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HousesListViewController.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "HomePageHousesCollectionViewCell.h"
#import "HouseDetialViewController.h"
#import "HouseListModel.h"
#import "HouseListRenchouCollectionViewCell.h"

@interface HousesListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;


/** 当前page */
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray *houses;

@property (nonatomic , strong) RealFinishTipView1 *tipView1;
@end

@implementation HousesListViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.title isEqualToString:@"我的关注"]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    
    self.view.backgroundColor = kListBgColor;
    [self viewInit];
    self.allView = _contentCollectionView;
    
    if ([self.title isEqualToString:@"浏览历史"] ||[self.title isEqualToString:@"我的关注"]) {
    UIButton *rigthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rigthButton setTitle:@"清空" forState:UIControlStateNormal];
    [rigthButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
    [rigthButton addTarget:self action:@selector(tipView1Clear) forControlEvents:UIControlEventTouchUpInside];
    rigthButton.titleLabel.font = kSysFont(16);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigthButton];
    }
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
    
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HouseListRenchouCollectionViewCell" bundle:[NSBundle bundleForClass:[HouseListRenchouCollectionViewCell class]]] forCellWithReuseIdentifier:@"HouseListRenchouCollectionViewCell"];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageHousesCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageHousesCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell"];
    self.houses = [NSMutableArray new];
    __weak typeof (self) weakSelf = self;
    self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.contentCollectionView.mj_footer resetNoMoreData];
        weakSelf.houses = [NSMutableArray new];
        [weakSelf reloadData];
    }];
    self.contentCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf reloadData];
    }];
    
    if ([self.title isEqualToString:@"我的关注"]) {
        self.backItem.hidden = YES;
    }
}



#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  _houses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.title isEqualToString:@"我的认筹"]) {
    
        HouseListRenchouCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HouseListRenchouCollectionViewCell" forIndexPath:indexPath];
        cell.model = _houses[indexPath.row];
        return cell;
    }
    HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];
    cell.model = _houses[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.title isEqualToString:@"我的认筹"]) {
        return CGSizeMake(SCREEN_WIDTH, 240);
    }
    return CGSizeMake((SCREEN_WIDTH-10)/2, 131*CustomScreenFit+88);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    HouseListModel *model = _houses[indexPath.row];
    vc.strBH = model.saleid;
//    if (!model.lpbh) {
//        vc.strBH = model.xmbh;
//    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)reloadData {
    if (_page == 0) {
        _page = 1;
    }
    NSString *strUrl = @"";
    if ([self.title isEqualToString:@"我的认筹"]) {
        strUrl = @"/api/family/xf/user/renchouhistory";
        
    }else if ([self.title isEqualToString:@"我的关注"]) {
        strUrl = @"/api/family/xf/user/guznzhulist";
        
    }else if ([self.title isEqualToString:@"浏览历史"]) {
        strUrl = @"/api/family/xf/user/mybrowsehistory";
        
    }
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(strUrl) para: @{@"page":[NSString stringWithFormat:@"%ld",_page],@"rows":@"20"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        [weakSelf loadingPageWidthSuccess:success];
        
        NSArray *tempArray = [NSArray new];
        if (success) {
            if ([self.title isEqualToString:@"我的认筹"]) {
                tempArray = [HouseListModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"list"]];

                [weakSelf.houses addObjectsFromArray:tempArray];
            }else{
                tempArray = [HouseListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                [weakSelf.houses addObjectsFromArray:tempArray];
            }
            
            [weakSelf.contentCollectionView reloadData];
            if (weakSelf.houses.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
        }
        [weakSelf.contentCollectionView.mj_header endRefreshing];
        [weakSelf.contentCollectionView.mj_footer endRefreshing];
        if (tempArray.count < 20) {
            [weakSelf.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}


- (void)tipView1Clear{
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _tipView1.contentTitleLabel.text = [NSString stringWithFormat:@"确定清空%@?",self.title];
    [_tipView1.sureButton addTarget:self action:@selector(loginoutFinishClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginoutFinishClick{//清空接口
    
    NSString *strUrl = @"/api/family/xf/user/delallrecord";
    if ([self.title isEqualToString:@"我的关注"]) {
        strUrl = @"/api/family/xf/user/delallfollows";
    }
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(strUrl) para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        if (success) {
            [weakSelf.houses removeAllObjects];
             [weakSelf.contentCollectionView reloadData];
            if (weakSelf.houses.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
        }
    }];
}
@end
