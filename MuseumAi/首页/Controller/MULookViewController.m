//
//  MULookViewController.m
//  MuseumAi
//
//  Created by Kingo on 2018/9/18.
//  Copyright © 2018年 Weizh. All rights reserved.
//

#import "MULookViewController.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "HomePageIconCollectionViewCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "HomePageBannerCollectionReusableView.h"
#import "HomePageNewsCollectionViewCell.h"
#import "HomePageHousesCollectionViewCell.h"
#import "HomePageHeaderCollectionReusableView.h"
#import "RealFirstTipViewController.h"
#import "RecognitionListViewController.h"
#import "SearchHouseListViewController.h"
#import "AllHousesListViewController.h"
#import "InformationLookoutViewController.h"
#import "NewsSegmentViewController.h"
#import "MyHouseListViewController.h"
#import "BannerModel.h"
#import "HouseListModel.h"
#import "ResultQualityViewController.h"
#import "HouseDetialViewController.h"
#import "ZTDetialViewController.h"

@interface MULookViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;
@property (nonatomic,strong) RealFinishTipView1 *tipView1;

/** 当前page */

@property (nonatomic , strong) NSMutableArray *banners;
@property (nonatomic , strong) NSMutableArray *midArray;
@property (nonatomic , strong) NSMutableArray *houses;

/** 8 */
@property (nonatomic , strong) NSArray *icons;
@property (nonatomic , strong) NSArray *titles;
@end


#define CarouselH (9.0f*SCREEN_WIDTH/16.0f-30)

#define SingleCellHeigh (303+362*CustomScreenFit)     //178+92*2 = 362
@implementation MULookViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [LoginSession sharedInstance].pageType = 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self dataInit];
    [self viewInit];
    [self customNav];
    
    self.allView = self.contentCollectionView;
    [[UINavigationBar appearance] setShadowImage: [self viewImageFromColor:kUIColorFromRGB(0xf7f7f7) rect:CGRectMake(0, 0, SCREEN_WIDTH, 1)]];
}


- (UIImage *)viewImageFromColor:(UIColor *)color rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titles.count;
    }else if (section == 1) {
        return self.midArray.count;//self.midArray.count;//第二模块
    }
    return  self.houses.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomePageIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageIconCollectionViewCell" forIndexPath:indexPath];
        cell.logoImage.image = [UIImage imageNamed:self.icons[indexPath.row]];
        [cell.titleLabel setText:self.titles[indexPath.row]];
        return cell;
    }else if (indexPath.section == 1) {
        HomePageNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageNewsCollectionViewCell" forIndexPath:indexPath];
        cell.model = self.midArray[indexPath.row];
        
//        cell.backGround.backgroundColor = kUIColorFromRGB(0xF1E9EB);
//        if (indexPath.row == 1) {
//            cell.backGround.backgroundColor = kUIColorFromRGB(0xE6EFEC);
//        }else if (indexPath.row == 2) {
//            cell.backGround.backgroundColor = kUIColorFromRGB(0xF2EEE4);
//        }
        
        return cell;
    }else if (indexPath.section == 2) {
        HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];
//        cell.coverImageView.image = [UIImage imageNamed:@"圆角矩形 4 拷贝-1"];
        cell.model = self.houses[indexPath.row];
        return cell;
    }

    HomePageIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageIconCollectionViewCell" forIndexPath:indexPath];
    cell.logoImage.image = [UIImage imageNamed:self.icons[indexPath.row]];
    [cell.titleLabel setText:self.titles[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return CGSizeMake((SCREEN_WIDTH-12)/3, 50*CustomScreenFit+22  +4);
    }else if (indexPath.section == 1) {
         return CGSizeMake((SCREEN_WIDTH-14)/2, 150*CustomScreenFit);
    }else if (indexPath.section == 2) {
        return CGSizeMake((SCREEN_WIDTH-1)/2,  122*CustomScreenFit +90  +4);
    }
    return CGSizeMake((SCREEN_WIDTH-12)/4, 77*CustomScreenFit);
}


//轮播图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ) {
        if (indexPath.section ==0) {
            HomePageBannerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageBannerCollectionReusableView" forIndexPath:indexPath];

            headerView.imageArray = self.banners;
            return headerView;
        }if (indexPath.section ==2 && self.houses.count) {
            HomePageHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView" forIndexPath:indexPath];
            headerView.topLine.hidden = YES;
            headerView.titleLabel.font = kSysFont(20);
            return headerView;
        }
        
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];;
    }else{
        if (indexPath.section ==2) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1" forIndexPath:indexPath];
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 500)];
            [headerView addSubview:backView];
            backView.backgroundColor = kListBgColor;
            
            UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
            [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
            [moreButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
            moreButton.titleLabel.font = kSysFont(13);
            [headerView addSubview:moreButton];
            moreButton.backgroundColor = kListBgColor;
            [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
            return headerView;
        }
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return CGSizeMake(SCREEN_WIDTH, (143+15));
    }if (section ==2 && self.houses.count) {
        return CGSizeMake(SCREEN_WIDTH, 51);
    }
    return CGSizeMake(SCREEN_WIDTH, 0.01);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section ==2) {
        return CGSizeMake(SCREEN_WIDTH, 46);
    }
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    self.banners = [NSMutableArray new];
    self.midArray = [NSMutableArray new];
    self.houses = [NSMutableArray new];
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/cover") para: @{@"page":@"1",@"rows":@"20"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        //banner
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            
            NSDictionary *dic = response[@"data"];
            for (NSDictionary *tempdic in [dic objectForKey:@"banner"]) {
                [self.banners addObject:[BannerModel mj_objectWithKeyValues:tempdic]];
            }
            for (NSDictionary *tempdic in [dic objectForKey:@"zt"]) {
                [self.midArray addObject:[NewsModel mj_objectWithKeyValues:tempdic]];
            }
            for (NSDictionary *tempdic in [dic objectForKey:@"recommend"]) {
                [self.houses addObject:[HouseListModel mj_objectWithKeyValues:tempdic]];
            }
            if (self.midArray.count%2) {
                [self.midArray removeLastObject];
            }
            if (self.houses.count%2) {
                [self.houses removeLastObject];
            }
            [LoginSession sharedInstance].rzzt = [dic objectForKey:@"newuser"][@"rzzt"];
            [LoginSession sharedInstance].grrzzt = [dic objectForKey:@"gr"][@"rzzt"];
            
            [weakSelf.contentCollectionView reloadData];
        }else{
        }
        [weakSelf.contentCollectionView.mj_header endRefreshing];
        [weakSelf.contentCollectionView.mj_footer endRefreshing];
    }];
    
}



#pragma mark - Click
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//8个坨坨
        switch (indexPath.row) {
            case 0:{

                if (![Utility is_empty:[LoginSession sharedInstance].grrzzt]) {
                    if ([[LoginSession sharedInstance].grrzzt integerValue] == 0||[[LoginSession sharedInstance].grrzzt integerValue] == 1) {
                        ResultQualityViewController *vc = [ResultQualityViewController new];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.isReal = NO;
                        [self.navigationController pushViewController:vc animated:YES];
                        return;
                    }
                }
                RealFirstTipViewController *vc = [RealFirstTipViewController new];
                vc.title = @"购房资格审查说明";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }break;
            case 1:{
                RecognitionListViewController *vc = [RecognitionListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }break;
            case 2:{//我的购房
                MyHouseListViewController *vc = [MyHouseListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
               
            }break;
            case 3:{
                
                InformationLookoutViewController *vc = [InformationLookoutViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case 4:{
                [self moreButtonClick];
                
            }break;
            case 5:{//楼市要闻
                NewsSegmentViewController *vc = [NewsSegmentViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            
            default:
                break;
        }
        return;
    }else if (indexPath.section == 1) {
        //        articles
        ZTDetialViewController *vc = [ZTDetialViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        NewsModel *model = self.midArray[indexPath.row];
        vc.formatString = model.ztnr;
        vc.title = model.title;
        if (model.title.length == 0) {
            vc.title = model.ztmc;
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2) {
        //        house
        HouseDetialViewController *vc = [HouseDetialViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        HouseListModel *model = self.houses[indexPath.row];
        vc.strBH = model.lpbh;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 已做
- (void)authenticationAction{
    if (_tipView1) {
        [_tipView1 customHidden];
    }
    RealFirstTipViewController *vc = [RealFirstTipViewController new];
    vc.title = @"关于实名认证";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)searchClick{
    SearchHouseListViewController *vc = [SearchHouseListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonClick{
    AllHousesListViewController *vc = [AllHousesListViewController new];
    vc.title = @"全部楼盘";
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航栏
- (void)customNav{
    
    UIImageView *left = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePage_navLeft"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 27, 15)];
    rightLabel.text = @"长沙";
    rightLabel.textColor = kUIColorFromRGB(0x616060);
    rightLabel.font = kSysFont(14);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightLabel];
    //    HomePageIconCollectionViewCell
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-120, 35)];
    [searchButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [searchButton setTitle:@"你想住哪里？" forState:UIControlStateNormal];
    [searchButton setTitleColor:kUIColorFromRGB(0xC0BEBE) forState:UIControlStateNormal];
    searchButton.titleLabel.font = kSysFont(14);
    searchButton.layer.cornerRadius = 2.0;
    searchButton.clipsToBounds = YES;
    searchButton.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    [searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.navigationItem setTitleView:searchButton];
    [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)dataInit{
    //    self.titles = @[@"实名认证",@"全部楼盘",   @"购房资格",@"精准找房",
    //                    @"信息查询",@"楼盘认筹",   @"购房百科",@"楼市要闻"];
    self.titles = @[ @"购房资格",@"楼盘认筹",@"我的购房",
                     @"信息查询",   @"全部楼盘",@"楼市要闻"];
    self.icons = @[@"homePage_item3",@"homePage_item6",   @"homePage_item7",
                   @"homePage_item5",@"homePage_item2",@"homePage_item8", ];
    //    self.icons = @[@"homePage_item1",@"homePage_item2",   @"homePage_item3",@"homePage_item4",
    //                   @"homePage_item5",@"homePage_item6",   @"homePage_item7",@"homePage_item8",];
}

- (void)viewInit {
    
    JYEqualCellSpaceFlowLayout * layout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithCenter betweenOfCell:0];
    layout.minimumLineSpacing = 0.01;
    layout.minimumInteritemSpacing = 0.01;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentCollectionView];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageIconCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageIconCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageIconCollectionViewCell"];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageNewsCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageNewsCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageNewsCollectionViewCell"];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageHousesCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageHousesCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell"];
    
    
    
    [self.contentCollectionView registerClass:[HomePageBannerCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageBannerCollectionReusableView"];
    [self.contentCollectionView registerClass:[HomePageHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView"];
    
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1"];
    
    __weak typeof (self) weakSelf = self;
    self.contentCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.contentCollectionView.mj_footer resetNoMoreData];
        [weakSelf reloadData];
    }];
    //    self.contentCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        weakSelf.page++;
    //        [weakSelf reloadData];
    //    }];
}

- (void)dealloc
{
//    [self.pageFlowView stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
