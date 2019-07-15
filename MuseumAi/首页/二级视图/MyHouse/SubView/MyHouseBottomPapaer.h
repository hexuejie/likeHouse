//
//  MyHouseBottomPapaer.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseBottomPapaer : UIView

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSArray *detialArray;

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

NS_ASSUME_NONNULL_END
