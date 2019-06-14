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

#import "HouseDetialMoreViewController.h"
#import "HouseDetialHeaderView.h"
#import "BuildingDetialViewController.h"
#import "HouseAroundViewController.h"
#import "HouseDetialFeedbackViewController.h"

@interface HouseDetialViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) HouseDetialHeaderView *headerView;

@property (strong, nonatomic) UICollectionView *contentCollectionView;
@property (strong, nonatomic) UIView *customNav;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backButton;


@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactWidth;

@property (nonatomic , strong) NSArray *titles;
@property (nonatomic , strong) NSArray *icons;

@property (nonatomic , assign) NSInteger page;
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
    
    [self dataInit];
    [self viewInit];
    [self customNavInit];
    
    [self.headerView.videoTipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.headerView.pictureTipButton setTitleColor:kUIColorFromRGB(0x444444) forState:UIControlStateNormal];
    self.headerView.videoTipButton.backgroundColor = kUIColorFromRGB(0xE8A660);
    self.headerView.pictureTipButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    self.headerView.countTipLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.43];
}


- (void)dataInit{
    self.titles = @[@"实名认证",@"全部楼盘",   @"购房资格",@"精准找房",
                    @"信息查询",@"楼盘认筹",   @"购房百科",@"楼市要闻"];
    self.icons = @[@"homePage_item1",@"homePage_item2",   @"homePage_item3",@"homePage_item4",
                   @"homePage_item5",@"homePage_item6",   @"homePage_item7",@"homePage_item8",];
}

- (void)viewInit {
    
    JYEqualCellSpaceFlowLayout * layout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithCenter betweenOfCell:0];
    layout.minimumLineSpacing = 0.01;
    layout.minimumInteritemSpacing = 0.01;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-52-0) collectionViewLayout:layout];
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
    self.headerView.frame = CGRectMake(0, -headerHight-20, SCREEN_WIDTH, headerHight);
//    _headerView.backgroundColor = [UIColor cyanColor];
    [self.contentCollectionView addSubview:self.headerView];
    self.headerView.model = @{};

    [self.contentCollectionView registerClass:[DetialHouseTypeCollectionViewCell class] forCellWithReuseIdentifier:@"DetialHouseTypeCollectionViewCell"];
    [self.contentCollectionView registerClass:[DetialHouseImageCollectionViewCell class] forCellWithReuseIdentifier:@"DetialHouseImageCollectionViewCell"];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"HomePageHousesCollectionViewCell" bundle:[NSBundle bundleForClass:[HomePageHousesCollectionViewCell class]]] forCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell"];

    [self.contentCollectionView registerClass:[HomePageHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView"];

    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1"];
    
    [self.headerView.moreButton addTarget:self action:@selector(moreDetialCilck) forControlEvents:UIControlEventTouchUpInside];

}


#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;//第二模块
    }else if (section == 2) {
        return 1;//第3模块  楼盘信息
    }
    return  4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetialHouseTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseTypeCollectionViewCell" forIndexPath:indexPath];
   
        return cell;
    }else if (indexPath.section == 1) {//楼栋信息
        DetialHouseImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseImageCollectionViewCell" forIndexPath:indexPath];
        cell.allImageView.image = [UIImage imageNamed:@"图层 67"];
        
        return cell;
    }else if (indexPath.section == 2) {//位置及周边
        DetialHouseImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseImageCollectionViewCell" forIndexPath:indexPath];
        cell.allImageView.image = [UIImage imageNamed:@"testMap"];
        
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
    return CGSizeMake((SCREEN_WIDTH-1)/2, 122*CustomScreenFit +90);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] ) {
        HomePageHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomePageHeaderCollectionReusableView" forIndexPath:indexPath];
        header.intoButton.hidden = NO;
        header.intoButton.tag = indexPath.section;
        header.titleLabel.font = kSysFont(16.0);
        if (indexPath.section == 0) {
            header.topLine.backgroundColor = [UIColor clearColor];
            header.titleLabel.text = @"主力户型（3）";
        }else{
            header.topLine.backgroundColor = kUIColorFromRGB(0xF4F4F4);
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
        
        [header.intoButton addTarget:self action:@selector(headerSectionClick:) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else{
        if (indexPath.section ==4) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView1" forIndexPath:indexPath];
            
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -2, SCREEN_WIDTH, 500)];
            [headerView addSubview:backView];
            backView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
            
            UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-80, 65)];
           
            NSString *texttext = @"免责申明：楼盘信息来源开发商，最终以政府部门备案为准，请谨慎核查！如楼盘信息有误或其他疑义，请点击反馈纠错，或拨打联系电话400-188-7055";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:texttext];
            NSRange range2 = [texttext rangeOfString:@"反馈纠错"];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xCDCDCB) range:NSMakeRange(0, [texttext length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xCF9E6A) range:range2];
            [moreButton setAttributedTitle:attributedString forState:UIControlStateNormal];
            moreButton.titleLabel.font = kSysFont(12);
            [headerView addSubview:moreButton];
            moreButton.backgroundColor = kUIColorFromRGB(0xF1F1F1);
            [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
            moreButton.titleLabel.numberOfLines = 0;
            moreButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            return headerView;
        }
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section ==0) {
//        return CGSizeMake(SCREEN_WIDTH, (143+15));
//    }if (section ==2) {
//        return CGSizeMake(SCREEN_WIDTH, 51);
//    }
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
        [self testButtonClick];
    }
}

#pragma mark - Event
- (void)headerSectionClick:(UIButton *)button{
    if (button.tag == 0) {
        [self.navigationController pushViewController:[HouseStyleViewController new] animated:YES];
    }else if (button.tag == 1) {
        [self.navigationController pushViewController:[BuildingDetialViewController new] animated:YES];
    }else if (button.tag == 2) {
        [self.navigationController pushViewController:[HouseAroundViewController new] animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.contentCollectionView) {
        if (scrollView.contentOffset.y >-330) {
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

- (void)moreDetialCilck{
    HouseDetialMoreViewController *vc = [HouseDetialMoreViewController new];
//    vc.title = @"反馈纠错";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreButtonClick{
   HouseDetialFeedbackViewController *vc = [HouseDetialFeedbackViewController new] ;
    vc.title = @"反馈纠错";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectionClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.collectImage.image = [UIImage imageNamed:@"detial_collectioned"];
        [SVProgressHelper dismissWithMsg:@"已关注"];
    }else{
        [SVProgressHelper dismissWithMsg:@"取消关注"];
        self.collectImage.image = [UIImage imageNamed:@"detial_collection"];
    }
    
    
    [self.collectionButton setImagePositionWithType:LXImagePositionTypeTop spacing:4];
}
- (IBAction)phoneQuestionClick:(id)sender {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"15116171468"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
    
- (IBAction)contactMeClick:(id)sender {
    
    HouseDetialFeedbackViewController *vc = [HouseDetialFeedbackViewController new] ;
    vc.title = @"联系商家";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)customNavInit{
    self.customNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.customNav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.customNav];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 20, 100, 44)];
    self.titleLabel.text = @"";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = kUIColorFromRGB(0x444444);
    self.titleLabel.font = kSysFont(18);
    [self.customNav addSubview:self.titleLabel];
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 20, 44, 44)];
    [self.backButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(callBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNav addSubview:self.backButton];
}

- (void)reloadData {
    //    __weak typeof(self) weakSelf = self;
    //
    //    //    @{@"page":@"1",@"rows":@"3",@"token":[LoginSession sharedInstance].token};
    //    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/zjw/user/cover") para: @{@"page":@"1",@"rows":@"3"} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
    //
    //        if (success) {
    //            NSDictionary *dic = response[@"data"];
    //            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"linkUrl"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //            [weakSelf.contentCollectionView reloadData];
    //
    //        }else{
    //            [weakSelf alertWithMsg:kFailedTips handler:nil];
    //        }
    //        [weakSelf.contentCollectionView.mj_header endRefreshing];
    //        [weakSelf.contentCollectionView.mj_footer endRefreshing];
    //        //            [weakSelf.contentCollectionView.mj_header endRefreshing];
    //        //            [weakSelf.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
    //    }];
}

@end
