//
//  HouseListRenchouCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/19.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseListRenchouCollectionViewCell.h"

@implementation HouseListRenchouCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 4.0;
    self.timeOutView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
}



- (void)setModel:(HouseListModel *)model{
    _model = model;
    
    self.titleLabel.text = _model.lpmc;
    if (!_model.lpmc) {
        self.titleLabel.text = _model.xmmc;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"均价：%@",_model.jj];
    self.timeLabel.text = [NSString stringWithFormat:@"认筹时间：%@",_model.rcsj];
    
    [self.coverImageView setOtherImageUrl:_model.img];
    
    self.contentLabel1.text = _model.kprq;
    self.contentLabel4.text = _model.kfsmc;
    
    self.contentLabel2.text = [NSString stringWithFormat:@"%@套",_model.ksts];
    self.contentLabel3.text = [NSString stringWithFormat:@"%@套",_model.gxts];
    self.contentLabel5.text = _model.addr;
    
    if ([_model.lpzt isEqualToString:@"认筹中"]) {
        self.timeOutView.hidden = YES;//
        self.backView.alpha = 1;
    }else{
        self.timeOutView.hidden = NO;//过期
        self.backView.alpha = 0.5;
    }
}


@end
