//
//  RecogtionHousesCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecogtionHousesCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *ChatTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTagLabel;


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentBeginLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *recogtionButton;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *viewview;

@end

NS_ASSUME_NONNULL_END
