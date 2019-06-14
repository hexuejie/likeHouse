//
//  HomePageHeaderCollectionReusableView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HomePageBannerCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageHeaderCollectionReusableView : HomePageBannerCollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *topLine;
@property (nonatomic,strong) UIButton *intoButton;
@end

NS_ASSUME_NONNULL_END
