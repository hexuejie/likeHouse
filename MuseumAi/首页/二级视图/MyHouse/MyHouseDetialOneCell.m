//
//  MyHouseDetialOneCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseDetialOneCell.h"

@implementation MyHouseDetialOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSecondTag:(BOOL)secondTag{
    _secondTag = secondTag;
    if (_secondTag) {
        _midSpase.constant = 172*CustomScreenFit;
    }else{//一个
        _midSpase.constant = 172*CustomScreenFit*2;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
