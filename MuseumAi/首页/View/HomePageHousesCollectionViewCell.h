//
//  HomePageHousesCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageHousesCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *ChatTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTagLabel;


@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;
@end

NS_ASSUME_NONNULL_END
