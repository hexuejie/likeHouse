//
//  MuHouseDetialHeader.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MuHouseDetialHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottom;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@end

NS_ASSUME_NONNULL_END
