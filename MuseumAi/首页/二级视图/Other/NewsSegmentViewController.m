//
//  NewsSegmentViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/8/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "NewsSegmentViewController.h"
#import "Utility.h"
#import "MessageListViewController.h"
#import "NewsListViewController.h"

@interface NewsSegmentViewController ()

@end

@implementation NewsSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"news_topImageView"]];
    topImage.frame = CGRectMake(0, [Utility segmentTopMinHeight], SCREEN_WIDTH, 120);
    UIView *bgTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120+[Utility segmentTopMinHeight])];
    [bgTopView addSubview:topImage];
    self.headView = bgTopView;
    bgTopView.backgroundColor = [UIColor redColor];
    self.headViewMaxHeight = 120+[Utility segmentTopMinHeight];
    self.headViewMinHeight = 120+[Utility segmentTopMinHeight];
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.title = @"楼市要闻";
    
    NewsListViewController *infoVC1 = [[NewsListViewController alloc] initWithNibName:nil bundle:nil];
    infoVC1.title = @"开盘预告";
    
    NewsListViewController *infoVC2 = [[NewsListViewController alloc] initWithNibName:nil bundle:nil];
    //    comboVC.shopId = self.shopId;
    infoVC2.title = @"星城楼市";
    
    NewsListViewController *infoVC3 = [[NewsListViewController alloc] initWithNibName:nil bundle:nil];
    //    comboVC.shopId = self.shopId;
    infoVC3.title = @"购房百科";
    
    self.subViewControllers = @[infoVC1,infoVC2,infoVC3];
    self.segmentedPager.bottomMarginHeight = 0;
    
    self.backItem.hidden = NO;
}



@end
