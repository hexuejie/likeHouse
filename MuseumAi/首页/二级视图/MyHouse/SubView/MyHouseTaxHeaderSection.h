//
//  MyHouseTaxHeaderSection.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/17.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseTaxHeaderSection : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;


@end

NS_ASSUME_NONNULL_END
