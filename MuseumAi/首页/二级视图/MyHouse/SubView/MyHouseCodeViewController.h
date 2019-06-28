//
//  MyHouseCodeViewController.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MURootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseCodeViewController : MURootViewController

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (assign, nonatomic) NSString *codeStr;

@property (strong, nonatomic) NSDictionary *pramDic;
@end

NS_ASSUME_NONNULL_END
