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
#import "zstListHousePicture.h"

@interface DetialPictureSegmentViewController ()

@end

@implementation DetialPictureSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.title = @"楼盘相册";//lx String 类型(type-album-xgt：效果图，type-album-ybt：样板图片，type-album-ptt：配套图片，type-album-zst：展示图片，type-vedio：视频，type-vr：VR)
    
//    效果图  1 lx
//    样板图  2
//    配套图  3
//    展示图  4
//
    
    DetialPicCollectionViewController *infoVC1 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
//    comboVC.shopId = self.shopId;
    infoVC1.title = @"效果图";
    
    DetialPicCollectionViewController *infoVC2 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
    //    comboVC.shopId = self.shopId;
    infoVC2.title = @"样板图";
    
    DetialPicCollectionViewController *infoVC3 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
    infoVC3.title = @"配套图";
    
    DetialPicCollectionViewController *infoVC4 = [[DetialPicCollectionViewController alloc] initWithNibName:nil bundle:nil];
    infoVC4.title = @"展示图";
    
    self.subViewControllers = @[infoVC1,infoVC2,infoVC3,infoVC4];
    self.segmentedPager.bottomMarginHeight = 0;
    
//    zstListHousePicture *picture = self.pictureArray[_currentIndex];
//    self.segmentedPager.segmentedControl.selectedSegmentIndex = [picture.lx integerValue]-1;
    
    NSMutableArray *array1 = [NSMutableArray new];
    NSMutableArray *array2 = [NSMutableArray new];
    NSMutableArray *array3 = [NSMutableArray new];
    NSMutableArray *array4 = [NSMutableArray new];
    for (zstListHousePicture *picture in self.pictureArray) {
        if ([picture.lx isEqualToString:@"type-album-xgt"]) {
            [array1 addObject:picture];
        }else if ([picture.lx isEqualToString:@"type-album-ybt"]) {
            [array2 addObject:picture];
        }else if ([picture.lx isEqualToString:@"type-album-ptt"]) {
            [array3 addObject:picture];
        }else if ([picture.lx isEqualToString:@"type-album-zst"]) {
            [array4 addObject:picture];
        }
    }
    infoVC1.pictureArray = array1;
    infoVC2.pictureArray = array2;
    infoVC3.pictureArray = array3;
    infoVC4.pictureArray = array4;
    

}


@end
