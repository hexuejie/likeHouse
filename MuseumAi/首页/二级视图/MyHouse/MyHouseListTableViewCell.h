//
//  MyHouseListTableViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHouseMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIButton *lookOutLabel;


@property (strong, nonatomic) MyHouseMode *model;;
@end

NS_ASSUME_NONNULL_END
