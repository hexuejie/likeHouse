//
//  MURootViewController.h
//  MuseumAi
//
//  Created by Kingo on 2018/9/18.
//  Copyright © 2018年 Weizh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUHttpDataAccess.h"
#import "MUMapHandler.h"
#import "MULoginViewController.h"
#import "UIViewController+MUExtension.h"

@interface MURootViewController : UIViewController

@property (nonatomic,strong) UIView *allView;

@property (nonatomic,strong) UIButton *backItem;

- (void)callBackClick;


- (void)reloadData;

- (void)addNoneDataTipView;
- (void)removeNoneDataTipView;

- (void)loadingPageError;
- (void)loadingPageSuccess;
- (void)loadingPageWidthSuccess:(BOOL)success;
@end
