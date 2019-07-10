//
//  DetialPictureSegmentViewController.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ESSegmentBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetialPictureSegmentViewController : ESSegmentBaseViewController

@property (nonatomic, strong) NSArray *pictureArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

NS_ASSUME_NONNULL_END
