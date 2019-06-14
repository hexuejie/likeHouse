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

@end
