//
//  ZTDetialBottomView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/22.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTDetialBottomView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (strong, nonatomic) HouseListModel *model;

@end

NS_ASSUME_NONNULL_END

