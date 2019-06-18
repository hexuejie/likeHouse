//
//  HomePageBannerCollectionReusableView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HomePageBannerCollectionReusableView.h"

@implementation HomePageBannerCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _bannerScrollView = [[IndexBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height-15)];
        _bannerScrollView.customdelegate = self;
       [self addSubview: _bannerScrollView];
    }
    return self;
}


- (void)setImageArray:(NSArray<AdModel *> *)imageArray{
    _imageArray = imageArray;
    _bannerScrollView.imageArray = _imageArray;
}

//- (void)scrollerIndexBannerView:(IndexBannerView *)view forIndex:(NSInteger)index{
//
//}

@end
