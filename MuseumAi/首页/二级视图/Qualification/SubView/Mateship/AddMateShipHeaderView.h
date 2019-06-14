//
//  AddMateShipHeaderView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddMateShipHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *addImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *addImageViewTwo;


@property (weak, nonatomic) IBOutlet UIButton *addButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *addButtonTwo;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;


@end

NS_ASSUME_NONNULL_END
