//
//  HomePageHousesCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HomePageHousesCollectionViewCell.h"

@implementation HomePageHousesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tipTagLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.backView.backgroundColor = kUIColorFromRGB(0xF4F4F4);
    
}


- (void)setModel:(HouseModel *)model{
    _model = model;
    
    self.titleLabel.text = _model.lpmc;
    self.contentLabel.text = _model.addr;
    if (_model.jj && ![_model.lpzt isKindOfClass:[NSNull class]]) {
        self.priceLabel.text = _model.jj;
    }else{
        self.priceLabel.text = @"价格待定";
    }
    if (_model.lpzt && ![_model.lpzt isKindOfClass:[NSNull class]]) {
        switch ([_model.lpzt integerValue]) {
            case 1:
                self.ChatTagLabel.text = @"认筹中";
                break;
            case 2:
                self.ChatTagLabel.text = @"待开盘";
                break;
            case 3:
                self.ChatTagLabel.text = @"认筹结束";
            case 4:
                self.ChatTagLabel.text = @"开盘待定";
                break;break;
                
            default:
                break;
        }
    }
    if (_model.bq && ![_model.bq isKindOfClass:[NSNull class]]) {
        self.tipTagLabel.text = _model.bq;
    }else{
        
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:BasePlaceholder]];

}
@end
