//
//  HouseModel.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hxlistVoHouseDetial.h"
#import "kpxmHouseDetial.h"
#import "lpHouseDetial.h"
#import "xmbcHouseDetial.h"
#import "zstListHousePicture.h"
#import "ldxxListHouseDetial.h"
#import "HouseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetialModel : NSObject


@property (nonatomic,copy) NSString *hxcount;//0,           户型数量
@property (nonatomic,copy) NSString *isfollow;//0,           //是否关注

@property (nonatomic,copy) NSString *imgcount;//24,
@property (nonatomic,copy) NSString *lpzt;//"开盘待定",       开盘状态 1待开盘2认筹中3认筹结束4开盘待定
@property (nonatomic,copy) NSString *kprq;//"待定",            日期

@property (nonatomic,copy) lpHouseDetial *lp;//Object{...},    楼盘信息
@property (nonatomic,copy) xmbcHouseDetial *xmbc;//Object{...},    项目补充信息
@property (nonatomic,copy) kpxmHouseDetial *kpxm;//Object{...}      //开盘项目
@property (nonatomic,copy) ldxxListHouseDetial *ldxx;    //楼栋信息

@property (nonatomic,copy) NSArray *zstList;//Array[24],    //展示图片  zstListHousePicture
@property (nonatomic,copy) NSArray *hxlistVo;//Array[1],     户型列表   hxlistVoHouseDetial


//HouseListModel
@property (nonatomic,copy) NSArray *zb;//Array[0],       周边   附近的楼盘
@property (nonatomic,copy) NSArray *list;//Array[0],        感兴趣的人还浏览了   ..楼盘列表
@property (nonatomic,copy) NSArray *near;//null,

@property (nonatomic,copy) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
//@property (nonatomic,copy) NSString *vr;//Array[0],
//@property (nonatomic,copy) NSString *vedio;//Array[0],
//@property (nonatomic,copy) NSString *dt;//null,        动态
