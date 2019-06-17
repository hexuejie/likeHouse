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

@interface MULookViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;
@property (nonatomic,strong) RealFinishTipView1 *tipView1;

/** 当前page */
@property (nonatomic , assign) NSInteger page;

@property (nonatomic , strong) NSArray *articles;
@property (nonatomic , strong) NSArray *houses;




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
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titles.count;
    }else if (section == 1) {
        return 4;//第二模块
    }else if (section == 1) {
        return 6;//第3模块  楼盘信息
    }
    return  8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomePageIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageIconCollectionViewCell" forIndexPath:indexPath];
        cell.logoImage.image = [UIImage imageNamed:self.icons[indexPath.row]];
        [cell.titleLabel setText:self.titles[indexPath.row]];
        return cell;
    }else if (indexPath.section == 1) {
        HomePageNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageNewsCollectionViewCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 2) {
        HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];
        cell.coverImageView.image = [UIImage imageNamed:@"圆角矩形 4 拷贝-1"];
        return cell;
    }

    HomePageIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageIconCollectionViewCell" forIndexPath:indexPath];
    cell.logoImage.image = [UIImage imageNamed:self.icons[indexPath.row]];
    [cell.titleLabel setText:self.titles[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return CGSizeMake((SCREEN_WIDTH-12)/3, 50*CustomScreenFit+22);
    }else if (indexPath.section == 1) {
         return CGSizeMake((SCREEN_WIDTH-14)/2, 150*CustomScreenFit);
    }else if (indexPath.section == 2) {
        return CGSizeMake((SCREEN_WIDTH-1)/2,  122*CustomScreenFit +90);
    }
    return CGSizeMake((SCREEN_WIDTH-12)/4, 77*CustomScreenFit);
}


//轮播图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ) {
        if (indexPath.section ==0) {
            HomePageBannerCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageBannerCollectionReusableView" forIndexPath:indexPath];
            
            AdModel *model = [AdModel new];
            model.linkUrl = @"https://github.com/hexuejie/likeHouse";
            model.img = @"http://app.cszjw.net:11000/img?path=/2018/11/29/154347341355531433612346213325856780.jpg";
            headerView.imageArray = @[model,model,model];
            return headerView;
        }if (indexPath.section ==2) {
            HomePageHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView" forIndexPath:indexPath];
            return headerView;
        }
        
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];;
    }else{
        if (indexPath.section ==2) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1" forIndexPath:indexPath];
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 500)];
            [headerView addSubview:backView];
            backView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
            
            UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
            [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
            [moreButton setTitleColor:kUIColorFromRGB(0xC0905D) forState:UIControlStateNormal];
            moreButton.titleLabel.font = kSysFont(13);
            [headerView addSubview:moreButton];
            moreButton.backgroundColor = kUIColorFromRGB(0xF1F1F1);
            [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
            return headerView;
        }
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return CGSizeMake(SCREEN_WIDTH, (143+15));
    }if (section ==2) {
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

//    @{@"page":@"1",@"rows":@"3",@"token":[LoginSession sharedInstance].token};
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/cover") para: @{@"page":@"1",@"rows":@"3"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        
        if (success) {
            NSDictionary *dic = response[@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"linkUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakSelf.contentCollectionView reloadData];
        }else{
           [weakSelf alertWithMsg:kFailedTips handler:nil];
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
//                [self authenticationAction];
                if (0) {
                    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
                    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
                    _tipView1.sureType = -1;
                    
                    [_tipView1.sureButton addTarget:self action:@selector(authenticationAction) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    RealFirstTipViewController *vc = [RealFirstTipViewController new];
                    vc.title = @"购房资格审查说明";
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }break;
            case 1:{
                RecognitionListViewController *vc = [RecognitionListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }break;
            case 2:{//我的购房
//                RecognitionListViewController *vc = [RecognitionListViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
               
            }break;
            case 3:{
                
            }break;
            case 4:{
                [self moreButtonClick];
                
            }break;
            case 5:{//楼市要闻
                RecognitionListViewController *vc = [RecognitionListViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            
            default:
                break;
        }
        return;
    }else if (indexPath.section == 1) {
        //        articles
    }else if (indexPath.section == 2) {
        //        houses
    }
    
    [self testButtonClick];
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
    
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        //        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if ([subview isKindOfClass:UIImageView.class] && subview.bounds.size.height <= 1.0) {
            subview.hidden = YES;
        }
    }
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
        weakSelf.page = 1;
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
