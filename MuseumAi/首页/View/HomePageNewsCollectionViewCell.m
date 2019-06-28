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
}


- (void)setModel:(NewsModel *)model{
    _model = model;
    
    self.titleLabel.text = _model.tgbt;
    self.contentLabel.text = _model.ztmc;
    [self.contentImage setOtherImageUrl:_model.img];
}
@end
