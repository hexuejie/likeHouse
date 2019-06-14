//
//  AddMateShipHeaderView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AddMateShipHeaderView.h"
#import "UIView+add.h"
#import "ChooseOtherRealViewController.h"

@implementation AddMateShipHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self layoutSubviews];
    
    self.imageWidth.constant = SCREEN_WIDTH*0.44;
    
    [self.addImageViewOne setBorderWithView:self.addImageViewOne.bounds];
    [self.addImageViewTwo setBorderWithView:self.addImageViewOne.bounds];
}
- (IBAction)otherRealClick:(id)sender {
//    [self.view];
    [LoginSession sharedInstance].pageType = 1;
    ChooseOtherRealViewController *realController = [[ChooseOtherRealViewController alloc] init];
    [[ProUtils getCurrentVC].navigationController pushViewController:realController animated:YES];
}



@end
