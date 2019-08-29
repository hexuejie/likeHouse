//
//  HouseDetialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseDetialViewController.h"
#import "UIButton+EdgeInsets.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "JYEqualCellSpaceFlowLayout.h"

#import "HouseStyleViewController.h"
#import "DetialHouseTypeCollectionViewCell.h"//户型
#import "DetialHouseImageCollectionViewCell.h"
#import "HomePageHousesCollectionViewCell.h"
#import "HomePageHeaderCollectionReusableView.h"

#import "ldxxListHouseDetial.h"
#import "HouseDetialMoreViewController.h"
#import "HouseDetialHeaderView.h"
#import "BuildingDetialViewController.h"
#import "HouseAroundViewController.h"
#import "HouseDetialFeedbackViewController.h"
#import "HouseDetialModel.h"
#import "SDPhotoBrowser.h"
#import "HouseDetialMapViewController.h"
#import "DetialCustomMapView.h"
#import "HouseDetialContactView.h"

@interface HouseDetialViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property (strong, nonatomic) HouseDetialHeaderView *headerView;

@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (strong, nonatomic) UIView *customNav;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;


@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactWidth;


@property (nonatomic , strong) HouseDetialModel *detialModel;


@property (nonatomic , assign) NSInteger clearSection;
@end

@implementation HouseDetialViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contactWidth.constant = 139*CustomScreenFit;
    [self.collectionButton setImagePositionWithType:LXImagePositionTypeTop spacing:4];
    
    [self viewInit];
    [self customNavInit];
    
    
    [self.headerView.videoTipButton setTitleColor:kUIColorFromRGB(0x444444) forState:UIControlStateNormal];
    self.headerView.videoTipButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.headerView.pictureTipButton.backgroundColor = kUIColorFromRGB(0xE8A660);
    [self.headerView.pictureTipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.headerView.countTipLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.43];
}



- (void)viewInit {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0.01;
    layout.minimumInteritemSpacing = 0.01;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-52-[Utility safeAreaBottomPlus]) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentCollectionView];
  
    CGFloat headerHight = 520;

    self.contentCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(headerHight, 0, 0, 0);
    self.contentCollectionView.contentInset = UIEdgeInsetsMake(headerHight, 0, 0, 0);
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"HouseDetialHeaderView" owner:self options:nil].firstObject;
    self.headerView.frame = CGRectMake(0, -headerHight-[Utility safeAreaTopStatus], SCREEN_WIDTH, headerHight);
//    _headerView.backgroundColor = [UIColor cyanColor];
    [self.contentCollectionView addSubview:self.headerView];


    [self.contentCollectionView registerClass:[DetialHouseTypeCollectionViewCell class] forCellWithReuseIdentifier:@"DetialHouseTypeCollectionViewCell"];
    [self.contentCollectionView registerClass:[DetialHouseImageCollectionViewCell class] forCellWithReuseIdentifier:@"DetialHouseImageCollectionViewCell"];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageHousesCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageHousesCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell"];

    [self.contentCollectionView registerClass:[HomePageHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView"];

    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1"];
    
    [self.headerView.moreButton addTarget:self action:@selector(moreDetialCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.locationBUtton addTarget:self action:@selector(locationButtonCilck) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0 && _detialModel.hxlistVo.count) {
        return 1;
    }else if (section == 1 && _detialModel.ldxx.img) {
        return 1;//楼栋
    }else if (section == 2 && _detialModel.lp.jd) {//wd
        return 1;//地图
    }else if (section == 3) {
        return _detialModel.list.count;//第3模块  楼盘信息
    }else if (section == 4) {
        return _detialModel.near.count;//第3模块  楼盘信息
    }
    return  0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetialHouseTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseTypeCollectionViewCell" forIndexPath:indexPath];
        cell.customSuperView = cell.contentView;
        cell.hxlistVo = _detialModel.hxlistVo;
        return cell;
    }else if (indexPath.section == 1) {//楼栋信息
        DetialHouseImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseImageCollectionViewCell" forIndexPath:indexPath];
        [cell.allImageView setOtherImageUrl:_detialModel.ldxx.img];
        cell.allImageView.hidden = NO;
        cell.mapView.hidden = YES;
        
        return cell;
    }else if (indexPath.section == 2) {//位置及周边
        DetialHouseImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseImageCollectionViewCell" forIndexPath:indexPath];
        cell.allImageView.hidden = YES;
        cell.mapView.hidden = NO;
        
        cell.mapView.coordinate = CLLocationCoordinate2DMake([self.detialModel.lp.wd doubleValue], [self.detialModel.lp.jd doubleValue]);
        cell.mapView.strTitle = self.detialModel.lp.xmdz;
        return cell;
    }else if (indexPath.section == 3) {//列表
        HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];

        cell.model = _detialModel.list[indexPath.row];
        return cell;
    }else if (indexPath.section == 4) {//附近的楼盘
        HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];

        cell.model = _detialModel.list[indexPath.row];
        return cell;
    }
    
    HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 210);
    }else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 253);
    }else if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 235);
    }
    return CGSizeMake((SCREEN_WIDTH-0.1)/2, 122*CustomScreenFit +90);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ) {
        if (indexPath.section == 0 && !_detialModel.hxlistVo) {
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        }else if (indexPath.section == 1 && !_detialModel.ldxx.img) {
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        }else if (indexPath.section == 2 && !_detialModel.lp.jd) {//wd
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        }else if (indexPath.section == 3 && !_detialModel.list.count) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            headerView.userInteractionEnabled = NO;
            return headerView;
        }else if (indexPath.section == 4 && !_detialModel.near.count) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            headerView.userInteractionEnabled = NO;
            return headerView;
        }
        
        HomePageHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView" forIndexPath:indexPath];
        header.intoButton.hidden = NO;
        header.intoButton.tag = indexPath.section;
        header.titleLabel.font = kSysFont(16.0);
        if (indexPath.section == 0) {
            header.titleLabel.text = [NSString stringWithFormat:@"主力户型（%ld）",_detialModel.hxlistVo.count];
        }else{
            if (indexPath.section == 1) {
                header.titleLabel.text = @"楼栋信息";
            }else if (indexPath.section == 2) {
                header.titleLabel.text = @"位置及周边";
            }else if (indexPath.section == 3) {
                header.intoButton.hidden = YES;
                header.titleLabel.text = @"对此楼盘感兴趣的人还浏览了";
            }else if (indexPath.section == 4) {
                header.intoButton.hidden = YES;
                header.titleLabel.text = @"附近楼盘";
            }
        }
        header.topLine.backgroundColor = kUIColorFromRGB(0xF4F4F4);
        if (_clearSection == indexPath.section) {
            header.topLine.backgroundColor = [UIColor clearColor];
        }
        
        [header.intoButton addTarget:self action:@selector(headerSectionClick:) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else{
        if (indexPath.section ==4) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1" forIndexPath:indexPath];
            headerView.backgroundColor = [UIColor redColor];
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 500)];
            [headerView addSubview:backView];
            backView.backgroundColor = kListBgColor;
            
            UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-80, 65)];
           
            NSString *texttext = @"免责申明：楼盘信息来源开发商，最终以政府部门备案为准，请谨慎核查！如楼盘信息有误或其他疑义，请点击反馈纠错，或拨打联系电话400-188-7055";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:texttext];
            NSRange range2 = [texttext rangeOfString:@"反馈纠错"];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xCDCDCB) range:NSMakeRange(0, [texttext length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xCF9E6A) range:range2];
            [moreButton setAttributedTitle:attributedString forState:UIControlStateNormal];
            moreButton.titleLabel.font = kSysFont(12);
            [headerView addSubview:moreButton];
            moreButton.backgroundColor = kListBgColor;
            [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
            moreButton.titleLabel.numberOfLines = 0;
            moreButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            return headerView;
        }
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0 && !_detialModel.hxlistVo) {
        _clearSection = 1;
        return CGSizeMake(SCREEN_WIDTH, 0.01);
    }else if (section == 1 && !_detialModel.ldxx.img) {
        if (_clearSection == 1) {
            _clearSection = 2;
        }
        return CGSizeMake(SCREEN_WIDTH, 0.01);
    }else if (section == 2 && !_detialModel.lp.jd) {//wd
        if (_clearSection == 2) {
            _clearSection = 3;
        }
        return CGSizeMake(SCREEN_WIDTH, 0.01);
    }else if (section == 3 && !_detialModel.list.count) {
        if (_clearSection == 3) {
            _clearSection = 4;
        }
        return CGSizeMake(SCREEN_WIDTH, 0.01);
    }else if (section == 4 && !_detialModel.near.count) {
        return CGSizeMake(SCREEN_WIDTH, 0.01);
    }
    return CGSizeMake(SCREEN_WIDTH, 51);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section ==4) {
        return CGSizeMake(SCREEN_WIDTH, 70);
    }
    return CGSizeMake(SCREEN_WIDTH, 0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= 3) {
        HouseDetialViewController *vc = [HouseDetialViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        if (indexPath.section == 3) {
            HouseListModel *model = _detialModel.list[indexPath.row];
            vc.strBH = model.saleid;
        }else if (indexPath.section == 4) {
            HouseListModel *model = _detialModel.near[indexPath.row];
            vc.strBH = model.saleid;
        }
        if (vc.strBH == nil) {
            [SVProgressHelper dismissWithMsg:@"楼盘编号为空！"];
            return;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if(indexPath.section == 0){
//        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];//设置容器视图,父视图
//        browser.sourceImagesContainerView = self.contentCollectionView;
//        browser.currentImageIndex = indexPath.row;
//        browser.imageCount = 1;//设置代理
//        browser.delegate = self;//显示图片浏览器
//        [browser show];
//        _detialModel.hxlistVo;
//    }
}


//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//    zstListHousePicture *picInfo = _pictureArray[index];//拿到显示的图片的高清图片地址
//    NSURL *url = [NSURL URLWithString:picInfo.img];
//    return url;
//    
//}
//
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    ImageUICollectionViewCell *cell = (ImageUICollectionViewCell *)[self.contentCollectionView cellForItemAtIndexPath:indexPath];
//    return cell.contentImage.image;
//    
//}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (scrollView == self.contentCollectionView) {
//        if(yOffset< -540)
//        {
//            CGFloat deviation = yOffset + 540;
//            CGRect frameImg= self.headerView.bannerScrollView.frame;
//            CGRect frame= self.headerView.frame;//_bannerScrollView
//            frame.origin.y=yOffset;
//            frame.size.height=-yOffset;
////            frame.origin.x = (yOffset* SCREEN_WIDTH/257+SCREEN_WIDTH)/2;
////            frame.size.width = -yOffset*SCREEN_WIDTH/257;
//            self.headerView.frame=frame;
//
//
//            frameImg.size.height = -deviation+257;//257
//            self.headerView.bannerScrollView.frame=frameImg;
//
//        }else
        if (yOffset >-330) {
            self.customNav.backgroundColor = [UIColor whiteColor];
            self.titleLabel.text = @"楼盘详情";
            [self.backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        }else{
            self.customNav.backgroundColor = [UIColor clearColor];
            self.titleLabel.text = @"";
            [self.backButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Event
- (void)headerSectionClick:(UIButton *)button{
    if (button.tag == 0) {
       HouseStyleViewController *vc = [HouseStyleViewController new];
        vc.hxlistVo = self.detialModel.hxlistVo;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag == 1) {
        BuildingDetialViewController *vc = [BuildingDetialViewController new];
        vc.strBH = self.strBH;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (button.tag == 2) {
        HouseAroundViewController *vc = [HouseAroundViewController new];
        vc.zbArray = self.detialModel.zb;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)locationButtonCilck{
    NSLog(@"\nself.detialModel.lp.wd : %@      self.detialModel.lp.jd: %@\n",self.detialModel.lp.wd,self.detialModel.lp.jd);
    HouseDetialMapViewController *vc = [HouseDetialMapViewController new];
    vc.strTitle = self.detialModel.lp.xmdz;
    vc.coordinate = CLLocationCoordinate2DMake([self.detialModel.lp.wd doubleValue], [self.detialModel.lp.jd doubleValue]);
//    vc.detialModel = self.detialModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreDetialCilck{
    HouseDetialMoreViewController *vc = [HouseDetialMoreViewController new];
    vc.detialModel = self.detialModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonClick{
   HouseDetialFeedbackViewController *vc = [HouseDetialFeedbackViewController new] ;
    vc.title = @"反馈纠错";
    vc.strBH = self.strBH;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString *strURL;
    if (sender.selected) {
        strURL = @"/api/family/xf/user/guznzhu";
    }else{
        strURL = @"/api/family/xf/user/quexiaoguznzhu";
    }
    
    __weak typeof(self) weakSelf = self;
    if (!_strBH) {
        _strBH = @"";
    }
    [[NetWork shareManager] postWithUrl:DetailUrlString(strURL) para:@{@"saleid":_strBH} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        if (success) {
            if (sender.selected) {
                weakSelf.collectImage.image = [UIImage imageNamed:@"detial_collectioned"];
                [SVProgressHelper dismissWithMsg:@"已关注"];
            }else{
                [SVProgressHelper dismissWithMsg:@"取消关注"];
                weakSelf.collectImage.image = [UIImage imageNamed:@"detial_collection"];
            }
            [weakSelf.collectionButton setImagePositionWithType:LXImagePositionTypeTop spacing:4];
            
        }else{
        }
    }];
}

- (IBAction)phoneQuestionClick:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_detialModel.lp.slclxdh];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
    
- (IBAction)contactMeClick:(id)sender {
    
//    HouseDetialFeedbackViewController *vc = [HouseDetialFeedbackViewController new] ;
//    vc.title = @"联系商家";
//    vc.strBH = self.strBH;
//    [self.navigationController pushViewController:vc animated:YES];
    
    HouseDetialContactView * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"HouseDetialContactView" owner:self options:nil].firstObject;
    _tipView1.strBH = self.strBH;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
}

- (void)customNavInit{
    self.customNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Utility segmentTopMinHeight])];
    self.customNav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.customNav];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, [Utility safeAreaTopStatus], 100, 44)];
    self.titleLabel.text = @"";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = kUIColorFromRGB(0x444444);
    self.titleLabel.font = kSysFont(18);
    [self.customNav addSubview:self.titleLabel];
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(5, [Utility safeAreaTopStatus], 44, 44)];
    [self.backButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(callBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNav addSubview:self.backButton];
}

- (void)reloadData {
        __weak typeof(self) weakSelf = self;
    if (!_strBH) {
        _strBH = @"";
    }//xqly Integer 详情来源  (1,banner,2,专题,3,新闻,4,推荐,5,其他)
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/newhousedetail") para:@{@"saleid":_strBH,@"xqly":@"5"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
    
            [weakSelf loadingPageWidthSuccess:success];
            if (success) {
                weakSelf.detialModel = [HouseDetialModel mj_objectWithKeyValues:response[@"data"]];
                weakSelf.detialModel.dataDic = response[@"data"];
    
                
                if (weakSelf.detialModel.list.count%2) {
                    [weakSelf.detialModel.list removeLastObject];
                }
                if (weakSelf.detialModel.near.count%2) {
                    [weakSelf.detialModel.near removeLastObject];
                }
               
                [weakSelf customReloaddata];
            }else{
            }
            [weakSelf.contentCollectionView.mj_header endRefreshing];
            [weakSelf.contentCollectionView.mj_footer endRefreshing];
        }];
}

- (void)customReloaddata{
    
    self.headerView.model = self.detialModel;
    if ([self.detialModel.isfollow boolValue]) {
        self.collectionButton.selected = YES;
        self.collectImage.image = [UIImage imageNamed:@"detial_collectioned"];
        [self.collectionButton setImagePositionWithType:LXImagePositionTypeTop spacing:4];
    }else{
        self.collectionButton.selected = NO;
        self.collectImage.image = [UIImage imageNamed:@"detial_collection"];
        [self.collectionButton setImagePositionWithType:LXImagePositionTypeTop spacing:4];
    }
    _clearSection = 0;
    [self.contentCollectionView reloadData];
}
@end
