//
//  HouseDetialHeaderView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexBannerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetialHeaderView : UIView<IndexBannerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipCenter;//38   0
@property (weak, nonatomic) IBOutlet UIButton *videoTipButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureTipButton;
@property (weak, nonatomic) IBOutlet UILabel *countTipLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (strong, nonatomic) NSDictionary *model;

@property (nonatomic,strong)IndexBannerView *bannerScrollView;
@end

NS_ASSUME_NONNULL_END
