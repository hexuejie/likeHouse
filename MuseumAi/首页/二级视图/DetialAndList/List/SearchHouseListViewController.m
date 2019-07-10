//
//  SearchHouseListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "SearchHouseListViewController.h"
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
#import "AllHousesListViewController.h"

@interface SearchCollectionReusableView : UICollectionReusableView<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *clearButton;
@end

@implementation SearchCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 24, SCREEN_WIDTH-50, 20)];
        _contentLabel.textColor = kUIColorFromRGB(0x242425);
        _contentLabel.font = kSysFont(14);
        [self addSubview: _contentLabel];
        
        _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, 24, 40, 30)];
        [_clearButton setTitleColor:kUIColorFromRGB(0x73757F) forState:UIControlStateNormal];
        [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
        _clearButton.titleLabel.font = kSysFont(14);
        [self addSubview: _clearButton];
    }
    return self;
}
@end

@interface SearchCollectionViewCell :UICollectionViewCell

@property (nonatomic,strong) UIImageView *contentImage;

@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation SearchCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}
//F5F4FD    FDF2F3   FEFBF0    F2FEF1   F3FBFC
- (void)setup{
    self.contentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.textColor = kUIColorFromRGB(0x73757F);
    self.contentLabel.font = kSysFont(13.0);
    self.contentLabel.numberOfLines = 1;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.textAlignment =NSTextAlignmentCenter;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.leading.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-9);
        make.trailing.equalTo(self.contentView).offset(-15);
    }];
}
@end



@interface SearchHouseListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *contentCollectionView;
//@property (nonatomic,strong) RealFinishTipView1 *tipView1;

@property (nonatomic , strong) NSArray *recentArray;
@property (nonatomic , strong) NSArray *hotArray;
@property (nonatomic , strong) NSArray *colorArray;

@property(nonatomic,strong)UITextField *searchBar;
@end

@implementation SearchHouseListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/search/hot") para: @{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            weakSelf.hotArray = response[@"data"];
            [weakSelf dataReloadData];//数据刷新
            
            //            [weakSelf.contentCollectionView reloadData];
            
        }else{
        }
        [weakSelf.contentCollectionView.mj_header endRefreshing];
        [weakSelf.contentCollectionView.mj_footer endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewInit];
    [self customNav];
    [self dataReloadData];
}

- (void)dataReloadData{
    
    self.recentArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"recentArray"];

    self.colorArray = @[kUIColorFromRGB(0xF5F4FD),kUIColorFromRGB(0xFDF2F3),kUIColorFromRGB(0xFEFBF0),
                      kUIColorFromRGB(0xF2FEF1),  kUIColorFromRGB(0xF3FBFC)];
     [self.contentCollectionView reloadData];
}

- (void)viewInit {
    
//    UICollectionViewLayout * layout = [[UICollectionViewLayout alloc]init];
//    layout.minimumLineSpacing = 12;
//    layout.minimumInteritemSpacing = 10;
    JYEqualCellSpaceFlowLayout *layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:10];
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 12, 5, 12);
    
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentCollectionView];
    [self.contentCollectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"SearchCollectionViewCell"];
  
    [self.contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    [self.contentCollectionView registerClass:[SearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchCollectionReusableView"];
    
}

#pragma mark - degelte
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.recentArray.count;
    }
    return  self.hotArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.contentLabel.text = self.recentArray[indexPath.row];
    }else{
        cell.contentLabel.text = self.hotArray[indexPath.row][@"ssmc"];
    }//
    int i = rand() % 5;
    cell.contentView.backgroundColor = self.colorArray[i];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat rowWidth = [self sizeWithText:self.recentArray[indexPath.row] font:kSysFont(13)].width;
        return CGSizeMake(rowWidth +30, 30);
    }else{
        CGFloat rowWidth = [self sizeWithText:self.hotArray[indexPath.row][@"ssmc"] font:kSysFont(13)].width;
        return CGSizeMake(rowWidth +30, 30);
    }
    return CGSizeMake(0.01, 0.01);
}


//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    SearchCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchCollectionReusableView" forIndexPath:indexPath];
    headerView.contentLabel.text = @"";
    [headerView.clearButton addTarget:self action:@selector(clearHeaderClick) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.section == 0) {
        headerView.clearButton.hidden = NO;
        headerView.contentLabel.text  = @"最近搜索";
    }else if (indexPath.section == 1) {
        headerView.clearButton.hidden = YES;
        headerView.contentLabel.text  = @"热门搜索";
    }
    return headerView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 55);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AllHousesListViewController *vc = [AllHousesListViewController new];
    
    if (indexPath.section == 0) {
        vc.keyString = self.recentArray[indexPath.row];
    }else{
        vc.keyString = self.hotArray[indexPath.row][@"ssmc"];
    }
    [self addAcacheForKey:vc.keyString];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchClik{
    [self addAcacheForKey:self.searchBar.text];
    AllHousesListViewController *vc = [AllHousesListViewController new];
    vc.keyString = self.searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addAcacheForKey:(NSString *)keyString{
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.recentArray];
    if (![tempArray containsObject:keyString]) {
        [tempArray addObject:keyString];
    }
    NSMutableArray *addArray = [[NSMutableArray alloc]initWithArray:tempArray];
    [addArray removeObject:keyString];
    tempArray = [[NSMutableArray alloc]initWithObjects:keyString, nil];
    [tempArray addObjectsFromArray:addArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"recentArray"];
    [self dataReloadData];//数据刷新
}

- (void)clearHeaderClick{
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"recentArray"];
    [self dataReloadData];//数据刷新
}

#pragma mark - 导航栏
- (void)customNav{
    
    UIButton *rightLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 15)];
//    rightLabel.text = @"搜索";
    [rightLabel setTitle:@"搜索" forState:UIControlStateNormal];
    [rightLabel setTitleColor:kUIColorFromRGB(0x616060) forState:UIControlStateNormal];
    rightLabel.titleLabel.font = kSysFont(14);
    [rightLabel addTarget:self action:@selector(searchClik) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightLabel];
    //    HomePageIconCollectionViewCell
    
    [self addSearchBar];
    
    for (UIView *subview in self.navigationController.navigationBar.subviews) {
        //        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (subview.bounds.size.height <= 1.0) {
            subview.hidden = YES;
        }
    }
}

- (void)addSearchBar{
   
    self.searchBar = [[UITextField alloc]initWithFrame:CGRectMake(0, -15, SCREEN_WIDTH-110, 35)];
    self.searchBar.layer.cornerRadius = 2.0;
    self.searchBar.clipsToBounds = YES;
    self.searchBar.tintColor = kUIColorFromRGB(0xC0BEBE);
    self.searchBar.font = [UIFont systemFontOfSize:14.0];
    self.searchBar.textColor = kUIColorFromRGB(0x444444);
    self.searchBar.returnKeyType = UIReturnKeyYahoo;
    self.searchBar.textAlignment = NSTextAlignmentLeft;
    self.searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.searchBar.backgroundColor = kUIColorFromRGB(0xF3F3F2);
    [self.searchBar setValue:kUIColorFromRGB(0xC0BEBE) forKeyPath:@"placeholderLabel.textColor"];
    [self.navigationItem setTitleView:self.searchBar];
    self.searchBar.delegate = self;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    leftView.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索"]];
    imgView.frame = CGRectMake(7, 5, 16, 16);
    [leftView addSubview:imgView];
    self.searchBar.leftView = leftView;
    self.searchBar.leftViewMode = UITextFieldViewModeAlways;
    self.searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchBar.placeholder = @"你想住在哪里？";

    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.contentCollectionView addGestureRecognizer:tableViewGesture];
    
}

- (void)commentTableViewTouchInSide{
    [self.view endEditing:YES];
}



/// 根据指定文本和字体计算尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxWidth:MAXFLOAT];
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)width
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil].size;
    return size;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        return NO;
    }
    [self searchClik];
    return YES;
}

@end

