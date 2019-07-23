//
//  HouseListRenchouCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/19.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseListRenchouCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel4;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel5;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *timeOutView;


@property (strong, nonatomic) HouseListModel *model;

@end

NS_ASSUME_NONNULL_END
