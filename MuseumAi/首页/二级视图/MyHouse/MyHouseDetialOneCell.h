//
//  MyHouseDetialOneCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseDetialOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midSpase;//172
@property (assign, nonatomic) BOOL secondTag;
@end

NS_ASSUME_NONNULL_END
