//
//  DetialPicCollectionViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialPicCollectionViewController.h"
#import "JYEqualCellSpaceFlowLayout.h"


@interface ImageUICollectionViewCell :UICollectionViewCell

@property (nonatomic,strong) UIImageView *contentImage;
@end

@implementation ImageUICollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.contentImage = [[UIImageView alloc]init];
    [self addSubview:self.contentImage];
    self.contentImage.image = [UIImage imageNamed:@"图层 29"];
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}
@end




@interface DetialPicCollectionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *contentCollectionView;

@property (nonatomic , assign) NSInteger page;
@end

@implementation DetialPicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataInit];
    [self viewInit];
}


- (void)dataInit{
    
}

- (void)viewInit {
    
    JYEqualCellSpaceFlowLayout * layout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:10];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.backgroundColor = [UIColor whiteColor];
    self.contentCollectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.contentCollectionView];
    
    
    [self.contentCollectionView registerClass:[ImageUICollectionViewCell class] forCellWithReuseIdentifier:@"ImageUICollectionViewCell"];
    [self.contentCollectionView reloadData];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageUICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat widthItem = (SCREEN_WIDTH-40)/3;
    return CGSizeMake(widthItem, widthItem*0.7);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

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
