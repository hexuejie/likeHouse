//
//  HouseDetialHeaderView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseDetialHeaderView.h"
#import "DetialPictureSegmentViewController.h"

@interface HouseDetialHeaderView ()<IndexBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerBackGround;
@property (weak, nonatomic) IBOutlet UIView *tipBackGround;



@end

@implementation HouseDetialHeaderView

- (void)setModel:(NSDictionary *)model{
    _model = model;
    
    if (!_bannerScrollView) {
        _bannerScrollView = [[IndexBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 257)];
        _bannerScrollView.customdelegate = self;
        [self.bannerBackGround addSubview: _bannerScrollView];
        _bannerScrollView.tag = 998;
    }
    
    
    
    BannerModel *model0 = [BannerModel new];
//    model0.linkUrl = @"https://github.com/hexuejie/likeHouse";
    model0.img = @"http://app.cszjw.net:11000/img?path=/2019/05/21/155839850061246820227271300382580249.jpg";
    _bannerScrollView.imageArray = @[model0,model0,model0];
    
    
    [self bringSubviewToFront:self.tipBackGround];
    self.tipBackGround.layer.zPosition = 5;
}

//- (void)scrollerIndexBannerView:(IndexBannerView *)view forIndex:(NSInteger)inde{
//
//}

@end
