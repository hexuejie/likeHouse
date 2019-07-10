//
//  DetialStyleCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hxlistVoHouseDetial.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetialStyleCollectionViewCell : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;


@property (nonatomic ,strong) hxlistVoHouseDetial *detial;
@end

NS_ASSUME_NONNULL_END
