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
    
    
    
    AdModel *model0 = [AdModel new];
    model0.linkUrl = @"https://blog.csdn.net/qq_33856343/article/details/52101488";
    model0.img = @"http://aliyunzixunbucket.oss-cn-beijing.aliyuncs.com/jpg/3835dc59023482b408db0819434b804b.jpg?x-oss-process=image/resize,p_100/auto-orient,1/quality,q_90/format,jpg/watermark,image_eXVuY2VzaGk=,t_100";
    _bannerScrollView.imageArray = @[model0,model0,model0];
    
    
    [self bringSubviewToFront:self.tipBackGround];
    self.tipBackGround.layer.zPosition = 5;
    
}

//- (void)scrollerIndexBannerView:(IndexBannerView *)view forIndex:(NSInteger)inde{
//
//}

@end
