//
//  ChooseQualificationTableViewCell.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ChooseQualificationTableViewCell.h"
#import "UIView+add.h"

@implementation ChooseQualificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.backGround setCornerRadius:5 withShadow:YES withOpacity:10];
//    [self.bgView2 setCornerRadius:5 withShadow:YES withOpacity:10];
//    [self.bgView3 setCornerRadius:5 withShadow:YES withOpacity:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
