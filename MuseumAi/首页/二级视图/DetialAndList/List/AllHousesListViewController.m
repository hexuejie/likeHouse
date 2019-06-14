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

@property (nonatomic , strong) NSArray *houses;

@property (weak, nonatomic) IBOutlet UIButton *chooseAreaButton;
@property (weak, nonatomic) IBOutlet UIButton *choosePriceButton;
@property (weak, nonatomic) IBOutlet UIButton *ChooseStyleButton;
@property (nonatomic, strong) YYFilterTool *filterTool;//永远返回一个单例对象

@property (nonatomic, assign) BOOL multiSelectionEnable;
@property (nonatomic, assign) BOOL topAndIndexCountEnable;
@property (nonatomic, assign) BOOL customImageEnable;

@property (nonatomic, strong) NSArray *sortFilters;
@end

@implementation AllHousesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self viewInit];
    [self customNav];
}

- (void)viewInit {
    [self.chooseAreaButton setImagePositionWithType:LXImagePositionTypeRight spacing:5];
    [self.choosePriceButton setImagePositionWithType:LXImagePositionTypeRight spacing:5];
    [self.ChooseStyleButton setImagePositionWithType:LXImagePositionTypeRight spacing:5];
    self.chooseAreaButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.choosePriceButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.ChooseStyleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 46 +[Utility segmentTopMinHeight], SCREEN_WIDTH-10, SCREEN_HEIGHT-46 -[Utility segmentTopMinHeight]) collectionViewLayout:layout];
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
}



#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomePageHousesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageHousesCollectionViewCell" forIndexPath:indexPath];
    
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
        //            [weakSelf.contentCollectionView.mj_header endRefreshing];
        //            [weakSelf.contentCollectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}

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
    self.filterTool.firstLevelElements = @[@"智能",@"智能排序",@"智能",@"智能排序",@"离我最近能排序能排序",@"好评优啊啊先",@"人气最高能排序"];
    self.filterTool.multiSelectionEnable = YES;
    switch (sender.tag) {
        case 0:{
            self.filterTool.multiSelectionEnable = NO;
        }break;
            
        default:
            break;
    }
    
//    self.filterTool.topConditionEnable = self.topAndIndexCountEnable;
//    self.filterTool.indexCountShowEnable = self.topAndIndexCountEnable;
//    if (self.customImageEnable) {
//        if (self.multiSelectionEnable) {
//            self.filterTool.selectedBtnHighlightedName = @"1";
//            self.filterTool.selectedBtnNormalName = @"2";
//        }  else {
//            self.filterTool.selectedBtnHighlightedName = @"3";
//            self.filterTool.selectedBtnNormalName = @"0";
//        }
//    }
    
    self.filterTool.currentConditions = [self.sortFilters mutableCopy];
    
    __weak typeof(self) weakSelf = self;
    NSMutableString *filterString = [NSMutableString new];
    self.filterTool.filterComplete = ^(NSArray *filters) {
        sender.selected = NO;
        weakSelf.sortFilters = filters;
        for (FilterSelectIndexModel *model in filters) {
            FilterSelectIndexModel *innermostModel = [YYFilterTool getInnermostIndexModelWith:model];
            NSInteger index = [filters indexOfObject:model];
            if (index == filters.count-1) {
                [filterString appendFormat:@"%@",innermostModel.filterName];
            } else {
                [filterString appendFormat:@"%@,",innermostModel.filterName];
            }
        }
        NSLog(@"%@",filterString);
        [SVProgressHelper dismissWithMsg:filterString];
        
        [sender setTitle:filterString forState:UIControlStateNormal];
        [sender setTitle:filterString forState:UIControlStateSelected];
        [sender setImagePositionWithType:LXImagePositionTypeRight spacing:5 maxWidth:(sender.bounds.size.width-25)];
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
