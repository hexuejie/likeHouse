//
//  MyHouseListTableViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseListTableViewCell.h"

@implementation MyHouseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lookOutLabel.layer.cornerRadius = 5.0;
    _lookOutLabel.layer.masksToBounds = YES;
    _lookOutLabel.layer.borderColor = MJThemeColor.CGColor;
    _lookOutLabel.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
