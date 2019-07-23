//
//  ZTDetialViewController.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/9.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MURootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTDetialViewController : MURootViewController

@property (nonatomic ,strong) NSString *formatString;
@property (nonatomic ,strong) NSDictionary *formatDic;


@property (nonatomic ,strong) NSString *urlString;
@property (nonatomic ,strong) NSDictionary *pramDic;

@end

NS_ASSUME_NONNULL_END
