//
//  NewsModel.h
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "BannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : BannerModel//动态


//@property (nonatomic,copy)NSString *bt;//"金地铂悦 韶山南 双地铁",
//@property (nonatomic,copy)NSString *nr;//链接图
//
//@property (nonatomic,copy)NSString *fbsj;//1
//@property (nonatomic,copy)NSString *fl;
//@property (nonatomic,copy)NSString *rdl;
////@property (nonatomic,copy)NSString *lpbh;


@property (nonatomic,copy)NSString *ztmc;//"金地铂悦 韶山南 双地铁",标签
@property (nonatomic,copy)NSString *ztnr;
@property (nonatomic,copy)NSString *fbt;//1
@property (nonatomic,copy)NSString *tgbt;
@property (nonatomic,copy)NSString *zd;

@property (nonatomic,copy)NSString *tjsj;//1
@property (nonatomic,copy)NSString *ztpx;

@end

NS_ASSUME_NONNULL_END
