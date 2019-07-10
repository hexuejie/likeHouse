//
//  DetialHouseTypeItem.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialHouseTypeItem.h"

@implementation DetialHouseTypeItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageType.layer.borderColor = kUIColorFromRGB(0xEBEBEA).CGColor;
    self.imageType.layer.borderWidth = 1.0;
}


- (void)setModel:(hxlistVoHouseDetial *)model{
    _model = model;
    
    [_imageType setOtherImageUrl:_model.img];
    _nameTyoeLabel.text = _model.hxmc;
    if ([_model.hxmj hasSuffix:@"㎡"]) {
        _sizeTypeLabel.text = _model.hxmj;
    }else{
        _sizeTypeLabel.text = [NSString stringWithFormat:@"建筑面积%@㎡",_model.hxmj];
    }
    _priceTypeLabel.text = [NSString stringWithFormat:@"%@",_model.xszj];//元/㎡
    if (![_model.xszj integerValue]) {
        _priceTypeLabel.text = @"价格待定";
    }
}
@end
