//
//  DetialHouseTypeItem.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialHouseTypeItem.h"

@implementation DetialHouseTypeItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageType.layer.borderColor = kUIColorFromRGB(0xEBEBEA).CGColor;
    self.imageType.layer.borderWidth = 1.0;
}

@end
