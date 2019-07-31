//
//  HouseAroundTableViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseAroundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleLogoImage;


@property (strong, nonatomic) NSArray *itemArray;
@end

NS_ASSUME_NONNULL_END
