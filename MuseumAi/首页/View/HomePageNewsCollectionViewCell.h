//
//  HomePageNewsCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePageNewsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

@property (weak, nonatomic) IBOutlet UIView *backGround;

@property (strong, nonatomic) NewsModel *model;
@end

NS_ASSUME_NONNULL_END
