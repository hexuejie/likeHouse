//
//  MyCenterLoginOutTableViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterLoginOutTableViewCell.h"

@implementation MyCenterLoginOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = kListBgColor;
    self.backgroundColor = kListBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
