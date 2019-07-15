//
//  DetialHouseTypeCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialHouseTypeCollectionViewCell.h"
#import "DetialHouseTypeItem.h"
#import "SDPhotoBrowser.h"

@interface DetialHouseTypeCollectionViewCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SDPhotoBrowserDelegate>

@end

@implementation DetialHouseTypeCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    
   UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.allTypeView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210) collectionViewLayout:flowLayout];
    self.allTypeView.delegate = self;
    self.allTypeView.dataSource = self;
    self.allTypeView.showsHorizontalScrollIndicator = NO;
    self.allTypeView.showsVerticalScrollIndicator = NO;
    self.allTypeView.showsHorizontalScrollIndicator = NO;
    self.allTypeView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.allTypeView];
    
    
    [self.allTypeView registerNib:[UINib nibWithNibName:@"DetialHouseTypeItem" bundle:[NSBundle bundleForClass:[DetialHouseTypeItem class]]] forCellWithReuseIdentifier:@"DetialHouseTypeItem"];
    
    [self.allTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(0);
        
        make.trailing.equalTo(self.contentView).offset(-0);
        make.bottom.equalTo(self.contentView).offset(-0);
    }];
}

- (void)setHxlistVo:(NSArray *)hxlistVo{
    _hxlistVo = hxlistVo;
    [self .allTypeView reloadData];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  _hxlistVo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetialHouseTypeItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialHouseTypeItem" forIndexPath:indexPath];
    cell.model = _hxlistVo[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(130, 205);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];//设置容器视图,父视图
//    browser.sourceImagesContainerView = self.customSuperView;
    browser.currentImageIndex = indexPath.row;
    browser.imageCount = _hxlistVo.count;//设置代理
    browser.delegate = self;//显示图片浏览器
    [browser show];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    hxlistVoHouseDetial *model = _hxlistVo[index];
    NSURL *url = [NSURL URLWithString:model.img];
    return url;
}
///api/family/xf/user/delrecord
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    DetialHouseTypeItem *cell = (DetialHouseTypeItem *)[self.allTypeView cellForItemAtIndexPath:indexPath];
    return cell.imageType.image;
    
}


@end
