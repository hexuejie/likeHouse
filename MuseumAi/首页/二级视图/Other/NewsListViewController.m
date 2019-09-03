//
//  NewsListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/8/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "NewsListViewController.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "NewsCollectionViewCell.h"
#import "HouseDetialViewController.h"
#import "HouseListModel.h"
#import "HouseListRenchouCollectionViewCell.h"
#import "NewsModel.h"
#import "ZTDetialViewController.h"

@interface NewsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;


/** 当前page */
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray *newsArray;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    self.view.backgroundColor = kListBgColor;
    [self viewInit];
    self.allView = _contentCollectionView;
}

- (void)viewInit {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-0, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = kListBgColor;
    [self.view addSubview:self.contentCollectionView];
    if ([self.title isEqualToString:@"楼盘动态"]||[self.title isEqualToString:@"悦居资讯"]) {
        self.contentCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -[Utility segmentTopMinHeight]-42);
    }else{
        self.contentCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -[Utility segmentTopMinHeight]-120-42);
    }
   
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"NewsCollectionViewCell" bundle:[NSBundle bundleForClass:[NewsCollectionViewCell class]]] forCellWithReuseIdentifier:@"NewsCollectionViewCell"];

    self.newsArray = [NSMutableArray new];
    __weak typeof (self) weakSelf = self;
    self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.contentCollectionView.mj_footer resetNoMoreData];
        weakSelf.newsArray = [NSMutableArray new];
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

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.newsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCollectionViewCell" forIndexPath:indexPath];
    NewsModel *model = self.newsArray[indexPath.row];
    
    cell.titleLabel.text = model.title;
    if (cell.titleLabel.text.length == 0) {
        cell.titleLabel.text = model.bt;
    }
    cell.timeLabel.text = model.publishdate;
    if (cell.timeLabel.text.length == 0) {
        cell.timeLabel.text = model.fbsj;
    }
    if (cell.timeLabel.text.length == 0) {
        cell.timeLabel.text = model.sj;
    }
    [cell.logoImageView setOtherImageUrl:model.img];
    
    if (cell.titleLabel.text.length) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cell.titleLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3.5; // 调整行间距
        NSRange range = NSMakeRange(0, [cell.titleLabel.text length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [cell.titleLabel setAttributedText:attributedString];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 94);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return CGSizeMake(SCREEN_WIDTH, 10.0);
//    }
    return CGSizeMake(SCREEN_WIDTH, 0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    HouseDetialViewController *vc = [HouseDetialViewController new];
//    vc.hidesBottomBarWhenPushed = YES;
//    HouseListModel *model = _newsArray[indexPath.row];
//    vc.strBH = model.saleid;
//    //    if (!model.lpbh) {
//    //        vc.strBH = model.xmbh;
//    //    }
//    [self.navigationController pushViewController:vc animated:YES];
    
    ZTDetialViewController *vc = [ZTDetialViewController new];
    NewsModel *model = self.newsArray[indexPath.row];
    vc.urlString = @"/api/family/xf/user/newsdetail";//动态
//    URL    http://zhifang.51vip.biz:8000/api/family/xf/user/newsdetail   //资讯
    vc.pramDic = @{@"bh":[NSString stringWithFormat:@"%@",model.bh]};

    if ([self.title isEqualToString:@"购房百科"]) {
        vc.urlString = @"/api/family/xf/user/baikedetail";//百科
        
    }else if ([self.title isEqualToString:@"楼盘动态"]) {
        vc.urlString = @"/api/family/xf/user/dynamicdetail";//动态
        
    }
    
    vc.formatString = model.ztnr;
    vc.title = self.title;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadData {
    if (_page == 0) {
        _page = 1;
    }
    NSString *strUrl = @"";
    NSString *flValue = @"";
    if ([self.title isEqualToString:@"开盘预告"]) {
        flValue = @"1";
        strUrl = @"/api/family/xf/user/marketnewslist";
        
    }else if ([self.title isEqualToString:@"星城楼市"]) {
        flValue = @"2";
        strUrl = @"/api/family/xf/user/marketnewslist";
        
    }else if ([self.title isEqualToString:@"购房百科"]) {
        strUrl = @"/api/family/xf/user/baikejzlist";
        
    }else if ([self.title isEqualToString:@"楼盘动态"]) {
        strUrl = @"/api/family/xf/user/dynamic";
        
    }else if ([self.title isEqualToString:@"悦居资讯"]) {
        strUrl = @"/api/family/xf/user/marketnewslist";
        
    }
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(strUrl) para: @{@"fl":flValue,@"page":[NSString stringWithFormat:@"%ld",_page],@"rows":@"20"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        [weakSelf loadingPageWidthSuccess:success];
        
        NSMutableArray *tempArray = [NSMutableArray new];
        if (success) {
            
            for (NSDictionary *tempDic in response[@"data"]) {
                NewsModel *temp = [NewsModel mj_objectWithKeyValues:tempDic];
                temp.bh = tempDic[@"id"];
                [tempArray addObject:temp];
            }
            [weakSelf.newsArray addObjectsFromArray:tempArray];
            
            [weakSelf.contentCollectionView reloadData];
            if (weakSelf.newsArray.count == 0) {
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

@end
