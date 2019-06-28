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

- (void)setModel:(MyHouseMode *)model{
    _model = model;
    
    self.titleLabel.text = _model.xmmc;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_model.dh,_model.sh];
    self.numberLabel.text = [NSString stringWithFormat:@"合同签订日期：%@",_model.htqdrq];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
