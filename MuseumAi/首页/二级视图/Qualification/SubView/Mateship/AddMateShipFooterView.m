//
//  AddMateShipFooterView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AddMateShipFooterView.h"
#import "UIView+add.h"

@implementation AddMateShipFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.addImageOne setBorderWithView:self.addImageOne.bounds];
    [self.addimageTwo setBorderWithView:self.addimageTwo.bounds];
    
    self.imageWidth.constant = SCREEN_WIDTH*0.44;
}


@end
