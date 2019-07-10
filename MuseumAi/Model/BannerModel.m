//
//  BannerModel.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel



- (void)setXmbh:(NSString *)xmbh{
    _xmbh = xmbh;
    
    if (!_xmbh && _lpbh) {
        _xmbh = _lpbh;
    }
    if ([_xmbh isKindOfClass:[NSNull class]]) {
        _xmbh = nil;
    }
}

//- (void)setXmmc:(NSString *)xmmc{
//    _xmmc = xmmc;
//    if (!_xmmc && _lp) {
//        _xmbh = _lpbh;
//    }
//}
@end
