//
//  DetialPictureSegmentViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/13.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialPictureSegmentViewController.h"
#import "DetialPicCollectionViewController.h"
#import "Utility.h"

@interface DetialPictureSegmentViewController ()

@end

@implementation DetialPictureSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeTop;
//    self.headViewMaxHeight = [Utility segmentTopMinHeight];
//    self.headViewMinHeight = [Utility segmentTopMinHeight];
    
    self.title = @"楼盘相册";
    
    DetialPicCollectionViewController *infoVC1 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
    infoVC1.title = @"视频";
    
    DetialPicCollectionViewController *infoVC2 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
//    comboVC.shopId = self.shopId;
    infoVC2.title = @"效果";
    
    DetialPicCollectionViewController *infoVC3 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
    //    comboVC.shopId = self.shopId;
    infoVC3.title = @"样板图";
    
    self.subViewControllers = @[infoVC1,infoVC2,infoVC3];
    self.segmentedPager.bottomMarginHeight = 0;
}


@end
