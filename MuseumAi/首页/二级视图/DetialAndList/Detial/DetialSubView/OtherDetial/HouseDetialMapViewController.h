//
//  HouseDetialMapViewController.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/19.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MURootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetialMapViewController : MURootViewController


@property (nonatomic,strong) NSString *strTitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end

NS_ASSUME_NONNULL_END
