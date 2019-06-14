//
//  AddMateShipFooterView.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/5.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddMateShipFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *addButtonTwo;

@property (weak, nonatomic) IBOutlet UIImageView *addImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *addimageTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@end

NS_ASSUME_NONNULL_END
