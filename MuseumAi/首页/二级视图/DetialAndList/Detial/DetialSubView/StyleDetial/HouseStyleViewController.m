//
//  HouseStyleViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseStyleViewController.h"
#import "UIButton+EdgeInsets.h"
#import "MUMapHandler.h"
#import "MJRefresh.h"
#import "hxlistVoHouseDetial.h"

#import "hxlistVoHouseDetial.h"
#import "DetialStyleCollectionViewCell.h"
#import "JYEqualCellSpaceFlowLayout.h"

@interface HouseStyleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *contentCollectionView;

@property (nonatomic , assign) NSInteger page;
@end

@implementation HouseStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"户型列表";

    [self viewInit];
    
}

- (void)viewInit {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0.01;
    layout.minimumInteritemSpacing = 0.01;
    self.contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.showsVerticalScrollIndicator = NO;
    self.contentCollectionView.showsHorizontalScrollIndicator = NO;
    self.contentCollectionView.backgroundColor = kUIColorFromRGB(0xF4F4F4);
    [self.view addSubview:self.contentCollectionView];

    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"DetialStyleCollectionViewCell" bundle:[NSBundle bundleForClass:[DetialStyleCollectionViewCell class]]] forCellWithReuseIdentifier:@"DetialStyleCollectionViewCell"];
    
}


#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  _hxlistVo.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetialStyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetialStyleCollectionViewCell" forIndexPath:indexPath];
    cell.detial = _hxlistVo[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-12)/2, 132*CustomScreenFit +105);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DetialStyleCollectionViewCell *cell = (DetialStyleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    RealFinishTipView1 * _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = 2;
    _tipView1.tipLabel.text = @"介绍";
    _tipView1.contentTitleLabel.text = cell.contentLabel.text;
    [_tipView1.sureButton setTitle:@"知道了" forState:UIControlStateNormal];
    [_tipView1 setContentLineSpacing:5];
}


- (void)setHxlistVo:(NSArray *)hxlistVo{
    _hxlistVo = hxlistVo;
    [self.contentCollectionView reloadData];
    
    if (_hxlistVo.count == 0) {
        [self addNoneDataTipView];
    }
}

@end
