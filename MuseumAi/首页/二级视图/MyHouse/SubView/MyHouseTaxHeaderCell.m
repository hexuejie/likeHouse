//
//  MyHouseTaxHeaderCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseTaxHeaderCell.h"
#import "UIView+add.h"

@implementation MyHouseTaxHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageWidth.constant = 335*CustomScreenFit;
   [self.backGround setCornerRadius:5 withShadow:YES withOpacity:5 withAlpha:0.1 withCGSize:CGSizeMake(0, 2)];
//    [self.codeBackGround setCornerRadius:5 withShadow:YES withOpacity:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
