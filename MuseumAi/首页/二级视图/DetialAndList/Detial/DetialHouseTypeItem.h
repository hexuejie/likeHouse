//
//  DetialHouseTypeItem.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hxlistVoHouseDetial.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetialHouseTypeItem : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageType;
@property (weak, nonatomic) IBOutlet UILabel *nameTyoeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTypeLabel;

@property (nonatomic, strong) hxlistVoHouseDetial *model;

@end

NS_ASSUME_NONNULL_END
