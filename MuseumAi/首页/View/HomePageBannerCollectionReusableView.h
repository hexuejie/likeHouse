//
//  HomePageBannerCollectionReusableView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexBannerView.h"
#import "BannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePageBannerCollectionReusableView : UICollectionReusableView<IndexBannerViewDelegate>

@property (nonatomic,strong)NSArray<BannerModel*> *imageArray;
@property (nonatomic,strong)IndexBannerView *bannerScrollView;


@property (nonatomic,strong)UIPageControl *pageControl;
@end

NS_ASSUME_NONNULL_END
