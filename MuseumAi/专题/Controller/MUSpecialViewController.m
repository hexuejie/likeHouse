//
//  MUSpecialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/5/27.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MUSpecialViewController.h"
#import "Utility.h"
#import "MessageListViewController.h"
#import "NewsListViewController.h"

@interface MUSpecialViewController ()

@end

@implementation MUSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeTop;
    self.headViewMaxHeight = [Utility segmentTopMinHeight];
    self.headViewMinHeight = [Utility segmentTopMinHeight];
    
    self.title = @"消息中心";
    
    MessageListViewController *infoVC1 = [[MessageListViewController alloc] initWithNibName:nil bundle:nil];
    infoVC1.title = @"系统消息";
    
    NewsListViewController *infoVC2 = [[NewsListViewController alloc] initWithNibName:nil bundle:nil];
    //    comboVC.shopId = self.shopId;
    infoVC2.title = @"楼盘动态";
    
    NewsListViewController *infoVC3 = [[NewsListViewController alloc] initWithNibName:nil bundle:nil];
    //    comboVC.shopId = self.shopId;
    infoVC3.title = @"悦居资讯";
    
    self.subViewControllers = @[infoVC1,infoVC2,infoVC3];
    self.segmentedPager.bottomMarginHeight = 0;
    
    self.backItem.hidden = YES;
}

@end
