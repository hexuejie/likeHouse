//
//  NewsModel.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject//动态




@property (nonatomic,copy)NSString *bt;//"金地铂悦 韶山南 双地铁",
@property (nonatomic,copy)NSString *nr;//链接图
@property (nonatomic,copy)NSString *fbsj;//1
@property (nonatomic,copy)NSString *sj;//1

@property (nonatomic,copy)NSString *fl;
@property (nonatomic,copy)NSString *rdl;


@property (nonatomic,copy)NSString *ztmc;//"金地铂悦 韶山南 双地铁",标签
@property (nonatomic,copy)NSString *ztnr;
@property (nonatomic,copy)NSString *fbt;//1
@property (nonatomic,copy)NSString *tgbt;
@property (nonatomic,copy)NSString *zd;

@property (nonatomic,copy)NSString *tjsj;//1
@property (nonatomic,copy)NSString *ztpx;


@property (nonatomic,copy)NSString *bh;
@property (nonatomic,copy)NSString *img;

//@property (nonatomic,copy)NSString *linkUrl;
@property (nonatomic,copy)NSString *sfxs;//是否显示
@property (nonatomic,copy)NSString *px;//排序

@property (nonatomic,copy)NSString *lpbh;//楼盘编号
@property (nonatomic,copy)NSString *lpmc;//楼盘编号

@property (nonatomic,copy)NSString *xmmc;//项目名称
@property (nonatomic,copy)NSString *xmbh;//楼盘编号  //跳转

@property (nonatomic,copy)NSString *publishdate;
@property (nonatomic,copy)NSString *title;//"金地铂悦 韶山南 双地铁",
@end

NS_ASSUME_NONNULL_END
