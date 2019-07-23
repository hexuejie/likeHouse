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
    self.backView.backgroundColor = kListBgColor;
    
}


- (void)setModel:(HouseListModel *)model{
    _model = model;
    
    _titleLabel.numberOfLines = 1;
    self.titleLabel.text = _model.lpmc;
    self.contentLabel.text = _model.addr;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",_model.jj] ;
    
    self.ChatTagLabel.text = [NSString stringWithFormat:@"%@",_model.lpzt];
    if (_model.lpzt && ![_model.lpzt isKindOfClass:[NSNull class]]) {
//        switch ([_model.lpzt integerValue]) {
//            case 1:
//                self.ChatTagLabel.text = @"认筹中";
//                break;
//            case 2:
//                self.ChatTagLabel.text = @"待开盘";
//                break;
//            case 3:
//                self.ChatTagLabel.text = @"认筹结束";
//            case 4:
//                self.ChatTagLabel.text = @"开盘待定";
//                break;break;
//
//            default:
//                break;
//        }
    }
    self.tipTagLabel.text = _model.bq;
    if (self.tipTagLabel.text.length >1) {
        self.tipTagLabel.hidden = NO;
    }else{
        self.tipTagLabel.hidden = YES;
    }
    [self.coverImageView setOtherImageUrl:_model.img];
}


@end
