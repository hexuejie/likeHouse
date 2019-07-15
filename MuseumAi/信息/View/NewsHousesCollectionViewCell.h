//
//  NewsHousesCollectionViewCell.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/12.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsHousesCollectionViewCell : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) NewsModel *newsModel;

@end

NS_ASSUME_NONNULL_END
