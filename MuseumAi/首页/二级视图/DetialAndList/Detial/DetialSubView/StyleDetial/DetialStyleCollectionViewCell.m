//
//  DetialStyleCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialStyleCollectionViewCell.h"

@implementation DetialStyleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backView.backgroundColor = kUIColorFromRGB(0xF4F4F4);
}


- (void)setDetial:(hxlistVoHouseDetial *)detial{
    _detial = detial;
    
    
    _coverImageView.layer.borderWidth = 1.0;
    _coverImageView.layer.borderColor = kUIColorFromRGB(0xeeedea).CGColor;
    
    [_coverImageView setOtherImageUrl:_detial.img];
    _titleLabel.text = _detial.hxmc;
    _contentLabel.text = _detial.hxjj;
    if (_contentLabel.text.length >0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2; // 调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_contentLabel.text length])];
        [_contentLabel setAttributedText:attributedString];
    }
    
    
    
    
    if ([_detial.hxmj hasSuffix:@"㎡"]) {
        _sizeLabel.text = _detial.hxmj;
    }else{
        _sizeLabel.text = [NSString stringWithFormat:@"%@㎡",_detial.hxmj];
    }
    _priceLabel.text = [NSString stringWithFormat:@"%@",_detial.xszj];//元/㎡
    if (![_detial.xszj integerValue]) {
        _priceLabel.text = @"价格待定";
    }
}
@end
