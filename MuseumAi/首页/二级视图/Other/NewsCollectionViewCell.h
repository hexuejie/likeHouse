//
//  NewsCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/8/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end

NS_ASSUME_NONNULL_END
