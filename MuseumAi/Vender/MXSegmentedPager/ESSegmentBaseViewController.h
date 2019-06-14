//
//  ESSegmentBaseViewController.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/17.
//  Copyright © 2017年 乐喜网. All rights reserved.
//
#import "MURootViewController.h"
#import "MXSegmentedPager.h"
//#import <MJRefresh/MJRefresh.h>

@interface ESSegmentBaseViewController  : MURootViewController<MXSegmentedPagerDelegate,MXSegmentedPagerDataSource>

@property (nonnull,nonatomic,strong,readonly) MXSegmentedPager *segmentedPager;
@property (nonnull,nonatomic,strong,readwrite) NSArray *subViewControllers;
@property (nullable,nonatomic,strong) UIView *headView;
@property (nonatomic, assign) CGFloat headViewMaxHeight;
@property (nonatomic, assign) CGFloat headViewMinHeight;


@end

