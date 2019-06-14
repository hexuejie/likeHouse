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

@end
