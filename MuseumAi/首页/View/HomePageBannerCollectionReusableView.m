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
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 -100, self.bounds.size.height-70, 200, 70)];
        [self.pageControl setPageIndicatorTintColor:kUIColorFromRGB(0xffffff)];
        [self.pageControl setCurrentPageIndicatorTintColor:kUIColorFromRGB(0xC0905D)];
        //    [self.pageControl setBackgroundColor:[UIColor blueColor]];
        [self addSubview:self.pageControl];
        self.pageControl.layer.zPosition = 3;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.defersCurrentPageDisplay = YES;
       
    }
    return self;
}


- (void)setImageArray:(NSArray<BannerModel *> *)imageArray{
    _imageArray = imageArray;
    _bannerScrollView.imageArray = _imageArray;
    
    
    self.pageControl.numberOfPages = _imageArray.count;
    NSLog(@"_imageArray.count  \n %ld",_imageArray.count);
}

- (void)scrollerIndexBannerView:(IndexBannerView *)view forIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
}

@end
