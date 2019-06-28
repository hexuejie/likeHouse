//
//  HouseListModel.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseListModel : NSObject


//认筹列表
@property (nonatomic,copy) NSString *tempId;// 0,
@property (nonatomic,copy) NSString *city;// "",
@property (nonatomic,copy) NSString *area;// "天心",
@property (nonatomic,copy) NSString *addr;// "天心区玉桂路59号",
@property (nonatomic,copy) NSString *jj;// "价格待定",
@property (nonatomic,copy) NSString *kprq;// "2018-10-11",
@property (nonatomic,copy) NSString *kpsj;// null,
@property (nonatomic,copy) NSString *kpjsrq;// "2019-10-15",
@property (nonatomic,copy) NSString *kpjssj;// null,
@property (nonatomic,copy) NSString *lpzt;// "认筹中",
@property (nonatomic,copy) NSString *zjmj;// null,
@property (nonatomic,copy) NSString *lplx;// "住宅、商业",
@property (nonatomic,copy) NSString *sjgqj;// null,
@property (nonatomic,copy) NSString *image;// null,
@property (nonatomic,copy) NSString *hxmjmax;// "48.1",
@property (nonatomic,copy) NSString *hxmjmin;// "48.1",
@property (nonatomic,copy) NSString *sfxsrc;// null,
@property (nonatomic,copy) NSString *lpbh;// "201806110829",
@property (nonatomic,copy) NSString *lpmc;// "鑫远紫越香苑",
@property (nonatomic,copy) NSString *province;// "",
@property (nonatomic,copy) NSString *bq;// "",
@property (nonatomic,copy) NSString *img;// "http://192.168.99.234/storage/15403858389573531869258636207927538.jpeg,http://192.168.99.234/storage/15403858389573531869258636207927538.jpeg,http://192.168.99.234/storage/15403858389573531869258636207927538.jpeg"


@end

NS_ASSUME_NONNULL_END
