//
//  DetialPicCollectionViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialPicCollectionViewController.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "zstListHousePicture.h"
#import "SDPhotoBrowser.h"

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
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
}
@end




@interface DetialPicCollectionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SDPhotoBrowserDelegate>

@property (strong, nonatomic) UICollectionView *contentCollectionView;

@property (nonatomic , assign) NSInteger page;
@end

@implementation DetialPicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataInit];
    [self viewInit];
    self.allView = self.contentCollectionView;
}


- (void)dataInit{
    
}

- (void)viewInit {
    
    JYEqualCellSpaceFlowLayout * layout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithLeft betweenOfCell:10];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -[Utility segmentTopMinHeight]-42) collectionViewLayout:layout];
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
    return  _pictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageUICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageUICollectionViewCell" forIndexPath:indexPath];
    zstListHousePicture *picture = _pictureArray[indexPath.row];
    [cell.contentImage setOtherImageUrl:picture.img];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat widthItem = (SCREEN_WIDTH-40)/3;
    return CGSizeMake(widthItem, widthItem*0.7);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];//设置容器视图,父视图
    browser.sourceImagesContainerView = self.contentCollectionView;
    browser.currentImageIndex = indexPath.row;
    browser.imageCount = _pictureArray.count;//设置代理
    browser.delegate = self;//显示图片浏览器
    [browser show];
    

}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    zstListHousePicture *picInfo = _pictureArray[index];//拿到显示的图片的高清图片地址
    NSURL *url = [NSURL URLWithString:picInfo.img];
    return url;
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    ImageUICollectionViewCell *cell = (ImageUICollectionViewCell *)[self.contentCollectionView cellForItemAtIndexPath:indexPath];
    return cell.contentImage.image;
    
}

- (void)setPictureArray:(NSArray *)pictureArray{
    _pictureArray = pictureArray;
    [self.contentCollectionView reloadData];
    if (_pictureArray.count == 0) {
        [self addNoneDataTipView];
    }
}


@end
