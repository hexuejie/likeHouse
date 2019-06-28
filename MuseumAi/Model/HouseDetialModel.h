//
//  HouseModel.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseDetialModel : NSObject
//list  楼盘列表 普通
//1
@property (nonatomic,copy)NSString *tempId;// 0,
@property (nonatomic,copy)NSString *city;// 长沙,
@property (nonatomic,copy)NSString *area;// 岳麓区,
@property (nonatomic,copy)NSString *addr;// 长沙市岳麓区洋湖大道罗谷塘路口东南角（洋湖湿地公园南门）,
@property (nonatomic,copy)NSString *jj;// 价格待定,
@property (nonatomic,copy)NSString *kprq;// ,
@property (nonatomic,copy)NSString *kpsj;// ,
@property (nonatomic,copy)NSString *kpjsrq;// ,
@property (nonatomic,copy)NSString *kpjssj;// ,
@property (nonatomic,copy)NSString *lpzt;// 开盘待定,
@property (nonatomic,copy)NSString *zjmj;// ,
@property (nonatomic,copy)NSString *lplx;// 住宅、公寓,
@property (nonatomic,copy)NSString *sjgqj;// ,
@property (nonatomic,copy)NSArray *image;
// [/2019/05/27/155891640525226880927789205022929587.jpg, /2019/05/27/155891641188180631127789211651559880.jpg, /2019/05/27/155891640870596781427789208475582849.jpg],
@property (nonatomic,copy)NSString *hxmjmax;// 142,
@property (nonatomic,copy)NSString *hxmjmin;// 113,
@property (nonatomic,copy)NSString *sfxsrc;// ,
@property (nonatomic,copy)NSString *province;// 湖南省,
@property (nonatomic,copy)NSString *bq;// 繁华地段,人车分流,
//@property (nonatomic,copy)NSString *lpbh;// WKP000000046,
//@property (nonatomic,copy)NSString *lpmc;// 映客龙湖·璟翠中心,
//
//@property (nonatomic,copy)NSString *img;// /2019/05/27/155891640525226880927789205022929587.jpg,/2019/05/27/15589164118818063112778921165155988

@end

NS_ASSUME_NONNULL_END
