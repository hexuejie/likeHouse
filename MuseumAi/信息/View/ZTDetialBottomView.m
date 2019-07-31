//
//  ZTDetialBottomView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/22.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ZTDetialBottomView.h"
#import "HouseDetialViewController.h"

@implementation ZTDetialBottomView

- (void)setModel:(HouseListModel *)model{
    _model = model;
    
    [self.coverImage setOtherImageUrl:_model.img];
    self.tagLabel.text = _model.lpzt;
    
    self.titleLabel.text = _model.lpmc;
    self.contentLabel.text = _model.addr;
    self.priceLabel.text = _model.jj;
}

- (IBAction)intoButton:(id)sender {
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.strBH = _model.saleid;
    if (!vc.strBH) {
        vc.strBH = _model.xmbh;
    }
    [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
