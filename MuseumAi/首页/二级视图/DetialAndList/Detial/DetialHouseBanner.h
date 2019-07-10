//
//  DetialHouseBanner.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "zstListHousePicture.h"


@class IndexBannerView;

@protocol IndexBannerViewDelegate <NSObject>

- (void)scrollerIndexBannerView:(IndexBannerView *)view forIndex:(NSInteger)index;
@end

@interface DetialHouseBanner : UIScrollView

@property (nonatomic,strong)NSArray<zstListHousePicture*> *imageArray;

@property (nonatomic, weak) id<IndexBannerViewDelegate> customdelegate;
@end

