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

- (void)setModel:(HouseDetialModel *)model{
    _model = model;
    
    if (!_bannerScrollView) {
        _bannerScrollView = [[DetialHouseBanner alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 257)];
        _bannerScrollView.customdelegate = self;
        [self.bannerBackGround addSubview: _bannerScrollView];
        _bannerScrollView.tag = 998;
    }
    
    _bannerScrollView.imageArray = _model.zstList;
    _countTipLabel.text = [NSString stringWithFormat:@"共%ld张",_model.zstList.count];
    _titleLabel.text = _model.lp.xmmc;
    _tagLabel.text = [_model.lp.bq stringByReplacingOccurrencesOfString:@"," withString:@"/"];
    _priceLabel.text = _model.lp.xmmc;
    _timeLabel.text = _model.kprq;
    _statueLabel.text = _model.lpzt;
    _addressLabel.text = _model.lp.xmdz;

//
    
    
    [self bringSubviewToFront:self.tipBackGround];
    self.tipBackGround.layer.zPosition = 5;
}
///xmbc  di'new
//"jd":"113.096968",
//"wd":"28.283927",
@end
