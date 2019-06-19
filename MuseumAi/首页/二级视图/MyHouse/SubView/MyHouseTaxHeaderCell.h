//
//  MyHouseTaxHeaderCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseTaxHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIMageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *backGround;

@property (weak, nonatomic) IBOutlet UIView *codeBackGround;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;


@end

NS_ASSUME_NONNULL_END
