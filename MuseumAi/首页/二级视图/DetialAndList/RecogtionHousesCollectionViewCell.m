//
//  RecogtionHousesCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "RecogtionHousesCollectionViewCell.h"

@implementation RecogtionHousesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tipTagLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.backView.backgroundColor = kUIColorFromRGB(0xf1f1f1);
    [self.contentView bringSubviewToFront:self.viewview];
}


- (void)setModel:(HouseListModel *)model{
    _model = model;
    
    [self.coverImageView setOtherImageUrl:_model.img];
    self.ChatTagLabel.text = _model.lpzt;
    self.tipTagLabel.text = _model.bq;
    self.titleLabel.text = _model.lpmc;
    self.contentBeginLabel.text = _model.kprq;
    self.contentEndLabel.text = _model.kpjsrq;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_model.jj];
    
    if (self.tipTagLabel.text.length >0) {
        self.tipTagLabel.hidden = NO;
    }else{
        self.tipTagLabel.hidden = YES;
    }
}
@end
