//
//  AllHousesListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AllHousesListViewController.h"
#import "UIButton+EdgeInsets.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "HomePageHousesCollectionViewCell.h"
#import "HouseDetialViewController.h"
#import "SearchHouseListViewController.h"
#import "YYFilterTool.h"

@interface AllHousesListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView *contentCollectionView;
@property (nonatomic,strong) UITextField *searchBar;

/** 当前page */
@property (nonatomic , assign) NSInteger page;

@property (nonatomic , strong) NSMutableArray *houses;

@property (weak, nonatomic) IBOutlet UIButton *chooseAreaButton;
@property (weak, nonatomic) IBOutlet UIButton *choosePriceButton;
@property (weak, nonatomic) IBOutlet UIButton *ChooseStyleButton;
@property (nonatomic, strong) YYFilterTool *filterTool;//永远返回一个单例对象

@property (nonatomic, assign) BOOL multiSelectionEnable;
@property (nonatomic, assign) BOOL topAndIndexCountEnable;
@property (nonatomic, assign) BOOL customImageEnable;

@property (nonatomic, strong) NSMutableArray *sortFilters1;
@property (nonatomic, strong) NSMutableArray *sortFilters2;
@property (nonatomic, strong) NSMutableArray *sortFilters3;
@end

@implementation AllHousesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kListBgColor;
    [self viewInit];
    [self customNav];
    self.allView = _contentCollectionView;
}

- (void)viewInit {
    CGFloat spacing = 10.0;
    [self.chooseAreaButton setImagePositionWithType:LXImagePositionTypeRight spacing:spacing];
    [self.choosePriceButton setImagePositionWithType:LXImagePositionTypeRight spacing:spacing];
    [self.ChooseStyleButton setImagePositionWithType:LXImagePositionTypeRight spacing:spacing];
    self.chooseAreaButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.choosePriceButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.ChooseStyleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 46 +[Utility segmentTopMinHeight], SCREEN_WIDTH-10, SCREEN_HEIGHT-46 -[Utility segmentTopMinHeight]) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.backgroundColor = kListBgColor;
    [self.view addSubview:self.contentCollectionView];
    
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
    
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    HouseListModel *model = self.houses[indexPath.row];
    vc.strBH = model.saleid;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)reloadData {
    if (_page == 0) {
        _page = 1;
    }
    NSMutableDictionary *pram = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":[NSString stringWithFormat:@"%ld",_page],@"rows":@"20"}];//搜索1 筛选2
    if (self.sortFilters1.count>0) {
        FilterSelectIndexModel *innermostModel = [self.sortFilters1 firstObject];
        if (innermostModel.filterName.length==3) {
            [pram setObject:innermostModel.filterName forKey:@"qu"];
        }
    }
    if (self.sortFilters2.count>0) {
        FilterSelectIndexModel *innermostModel = [self.sortFilters2 firstObject];
        if ([innermostModel.filterName isEqualToString:@"8000/㎡以下"]) {
            [pram setObject:@"0" forKey:@"sjgqj"];//最小
            [pram setObject:@"8000" forKey:@"ejgqj"];//最大
        }else if ([innermostModel.filterName isEqualToString:@"14000/㎡以上"]) {
            [pram setObject:@"14000" forKey:@"sjgqj"];//最小
            [pram setObject:@"999999" forKey:@"ejgqj"];//最大
            
        }else if ([innermostModel.filterName isEqualToString:@"8000/㎡-10000元/㎡"]) {
            [pram setObject:@"8000" forKey:@"sjgqj"];
            [pram setObject:@"10000" forKey:@"ejgqj"];
        }else if ([innermostModel.filterName isEqualToString:@"10000/㎡-12000元/㎡"]) {
            [pram setObject:@"10000" forKey:@"sjgqj"];
            [pram setObject:@"12000" forKey:@"ejgqj"];
        }else if ([innermostModel.filterName isEqualToString:@"12000/㎡-14000元/㎡"]) {
            [pram setObject:@"12000" forKey:@"sjgqj"];
            [pram setObject:@"14000" forKey:@"ejgqj"];
        }
    }
    if (self.sortFilters3.count>0) {//多选
        FilterSelectIndexModel *innermostModel = [self.sortFilters1 firstObject];
        if (![innermostModel.filterName isEqualToString:@"户型不限"]) {
            NSString *filterString;
            for (FilterSelectIndexModel *innermostModel in self.sortFilters3) {
                if (filterString == nil) {
                    filterString = [NSString stringWithFormat:@"%ld",innermostModel.index];
                } else {
                    filterString = [NSString stringWithFormat:@"%@,%ld",filterString,innermostModel.index];
                }
            }
            [pram setObject:filterString forKey:@"hx"];
        }
    }
    if ([pram.allKeys containsObject:@"qu"]||[pram.allKeys containsObject:@"ejgqj"]||[pram.allKeys containsObject:@"hx"]) {
        [pram setObject:@"2" forKey:@"sslx"];
    }
    if (_keyString.length>0) {
        [pram setObject:_keyString forKey:@"xmmc"];
    }
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/search/search") para:pram isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [weakSelf loadingPageWidthSuccess:success];
        
        NSArray *tempArray = [NSArray new];
        if (success) {
            NSDictionary *dic = response[@"data"];
            tempArray = [HouseListModel mj_objectArrayWithKeyValuesArray:dic];
            [weakSelf.houses addObjectsFromArray:tempArray];
            [weakSelf.contentCollectionView reloadData];
            if (weakSelf.houses.count == 0) {
                [weakSelf addNoneDataTipView];
            }
        }else{
            weakSelf.houses = @[];
            [weakSelf.contentCollectionView reloadData];
        }
        [weakSelf.contentCollectionView.mj_header endRefreshing];
        [weakSelf.contentCollectionView.mj_footer endRefreshing];
        if (tempArray.count < 20) {
            [weakSelf.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
//xmmc String 项目名称{普通搜索}
//hx String 户型{1：一室 2：二室 3：三室 4：四室 5：五室+}{精准搜索}
//kpsj Integer 开盘时间{1：即将开盘 2：一个月内 3：三个月内 4：半年内}{精准搜索}
//ts String 楼盘特色
//zx String 装修
//qu String 区域
//type Integer 价格类型 1：均价 2：总价
//lplx String 楼盘类型 1：住宅 2：商住 3：别墅 4：写字楼 5：商铺
//sslx Integer 搜索类型  1:普通搜索 2：精准搜索
#pragma mark - 导航栏
- (void)customNav{
    if (self.keyString.length) {
        
        [self addSearchBar];
    }else{
        self.title = @"全部楼盘";
        
        UIButton *rightLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 15)];
        //    rightLabel.text = @"搜索";
        [rightLabel setImage:[UIImage imageNamed:@"search_right"] forState:UIControlStateNormal];
        [rightLabel addTarget:self action:@selector(searchClik) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightLabel];
    }
    
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
    self.searchBar.text = self.keyString;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self searchClik];
    return NO;
}

- (void)searchClik{
    [self.navigationController pushViewController:[SearchHouseListViewController new] animated:YES];
}
- (void)callBackClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)chooseHeaderClick:(UIButton *)sender {

    sender.selected = YES;
    self.filterTool.multiSelectionEnable = NO;

    switch (sender.tag) {
        case 0:{
            self.filterTool.multiSelectionEnable = NO;
            self.filterTool.firstLevelElements =  @[@"区域不限",@"芙蓉区",@"天心区",@"雨花区",@"开福区",@"岳麓区",@"望城区",@"长沙县",@"宁乡市",@"浏阳市"].mutableCopy;
            self.filterTool.currentConditions =  self.sortFilters1;
        }break;
        case 1:{
            self.filterTool.multiSelectionEnable = NO;
            self.filterTool.firstLevelElements = @[@"价格不限",@"8000/㎡以下",@"8000/㎡-10000元/㎡",@"10000/㎡-12000元/㎡",@"12000/㎡-14000元/㎡",@"14000/㎡以上"].mutableCopy;
           self.filterTool.currentConditions =  self.sortFilters2;
        }break;
        case 2:{
            self.filterTool.multiSelectionEnable = YES;
            self.filterTool.firstLevelElements =  @[@"户型不限",@"一室",@"二室",@"三室",@"四室",@"四室以上"].mutableCopy;
           self.filterTool.currentConditions =  self.sortFilters3;
        }break;
        default:
            break;
    }

   
    
    __weak typeof(self) weakSelf = self;
    NSMutableString *filterString = [NSMutableString new];
    self.filterTool.filterComplete = ^(NSArray *filters) {
        sender.selected = NO;
        if (sender.tag == 0) {
            weakSelf.sortFilters1 = filters.mutableCopy;
        }else if (sender.tag == 1) {
            weakSelf.sortFilters2 = filters.mutableCopy;
            
        }else if (sender.tag == 2) {
            BOOL clearTag = NO;
            for (FilterSelectIndexModel *model in filters) {
                if ([model.filterName isEqualToString:@"户型不限"]) {
                    clearTag = YES;
                }
            }
            if (clearTag) {
                filters = [NSArray array];
            }
            if (filters.count == 0) {
                FilterSelectIndexModel *model = [FilterSelectIndexModel new];
                model.filterName = @"户型不限";
                filters = [[NSArray alloc]initWithObjects:model, nil];
                weakSelf.sortFilters3 = [NSMutableArray new];
            }else{
                weakSelf.sortFilters3 = filters.mutableCopy;
            }
        }
        for (FilterSelectIndexModel *model in filters) {
            FilterSelectIndexModel *innermostModel = [YYFilterTool getInnermostIndexModelWith:model];
            NSInteger index = [filters indexOfObject:model];
            if (index == filters.count-1) {
                [filterString appendFormat:@"%@",innermostModel.filterName];
            } else {
                [filterString appendFormat:@"%@,",innermostModel.filterName];
            }
        }
        
        [sender setTitle:filterString forState:UIControlStateNormal];
        [sender setTitle:filterString forState:UIControlStateSelected];
        [sender setImagePositionWithType:LXImagePositionTypeRight spacing:7 maxWidth:(sender.bounds.size.width-25)];
        weakSelf.houses = [NSMutableArray new];
        [weakSelf reloadData];
    };
    
    [self.filterTool popFilterViewWithStartY:(46 +[Utility segmentTopMinHeight]) startAnimateComplete:nil closeAnimateComplete:^{
        NSLog(@"关闭回调");
        sender.selected = NO;
    }];
}

- (YYFilterTool *)filterTool {
    if (!_filterTool) {
        _filterTool = [YYFilterTool shareInstance];
    }
    return _filterTool;
}


@end
