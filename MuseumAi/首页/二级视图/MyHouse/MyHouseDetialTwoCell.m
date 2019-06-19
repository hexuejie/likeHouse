//
//  MyHouseDetialTwoCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseDetialTwoCell.h"

@implementation MyHouseDetialTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerButton.layer.cornerRadius = 5.0;
    _headerButton.layer.masksToBounds = YES;
    _headerButton.layer.borderColor = MJThemeColor.CGColor;
    _headerButton.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
