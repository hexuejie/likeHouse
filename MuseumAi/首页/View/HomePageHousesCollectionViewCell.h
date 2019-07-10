//
//  HomePageHousesCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseListModel.h"
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageHousesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *ChatTagLabel;//认筹
@property (weak, nonatomic) IBOutlet UILabel *tipTagLabel;


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) NewsModel *newsModel;

@property (strong, nonatomic) HouseListModel *model;
@end

NS_ASSUME_NONNULL_END
