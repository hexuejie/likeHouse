//
//  IndexBannerView.h
//  banni
//
//  Created by zhudongliang on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdModel.h"

NS_ASSUME_NONNULL_BEGIN

@class IndexBannerView;

@protocol IndexBannerViewDelegate <NSObject>

- (void)scrollerIndexBannerView:(IndexBannerView *)view forIndex:(NSInteger)index;
@end

@interface IndexBannerView : UIScrollView

@property (nonatomic,strong)NSArray<AdModel*> *imageArray;

@property (nonatomic, weak) id<IndexBannerViewDelegate> customdelegate;
@end

NS_ASSUME_NONNULL_END
