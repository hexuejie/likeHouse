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

@interface HousesListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;


/** 当前page */
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSArray *houses;
@end

@implementation HousesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self viewInit];
}

- (void)viewInit {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.view addSubview:self.contentCollectionView];
    
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageHousesCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageHousesCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell"];
    
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
    
    if ([self.title isEqualToString:@"我的关注"]) {
        self.backItem.hidden = YES;
    }
}



#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  _houses.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];
    cell.model = _houses[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH-10)/2, 131*CustomScreenFit+88);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self testButtonClick];
}


- (void)reloadData {
    if ([self.title isEqualToString:@"我的认筹"]) {
        __weak typeof(self) weakSelf = self;
        [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/renchouhistory") para: @{@"page":@"1",@"rows":@"999"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
            
            if (success) {
                
                weakSelf.houses = [HouseListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
                [weakSelf.contentCollectionView reloadData];
                if (!weakSelf.houses) {
                    [weakSelf addNoneDataTipView];
                }
            }else{
                [weakSelf addNoneDataTipView];
                [weakSelf alertWithMsg:kFailedTips handler:nil];
            }
            [weakSelf.contentCollectionView.mj_header endRefreshing];
            [weakSelf.contentCollectionView.mj_footer endRefreshing];
            //            [weakSelf.contentCollectionView.mj_header endRefreshing];
            //            [weakSelf.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
        }];
    }
    
}


@end
