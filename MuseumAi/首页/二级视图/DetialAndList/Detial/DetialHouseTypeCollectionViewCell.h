//
//  DetialHouseTypeCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetialHouseTypeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UICollectionView *allTypeView;

@property (nonatomic,strong) NSArray *hxlistVo;


@property (nonatomic,strong) UIView *customSuperView;
@end

NS_ASSUME_NONNULL_END
