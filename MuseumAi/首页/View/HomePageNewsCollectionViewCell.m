//
//  HomePageNewsCollectionViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HomePageNewsCollectionViewCell.h"

@implementation HomePageNewsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backGround.layer.borderColor = kUIColorFromRGB(0xf2f2f0).CGColor;
    self.backGround.layer.borderWidth = 1.0;
}


- (void)setModel:(NewsModel *)model{
    _model = model;
    
    self.titleLabel.text = _model.tgbt;
    self.contentLabel.text = _model.ztmc;
    [self.contentImage setOtherImageUrl:_model.img];
}
@end
