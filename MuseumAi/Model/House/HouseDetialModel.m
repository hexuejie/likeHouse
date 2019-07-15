//
//  HouseModel.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/14.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "HouseDetialModel.h"

@implementation HouseDetialModel

- (void)setHxlistVo:(NSArray *)hxlistVo{//hxlistVoHouseDetial
    _hxlistVo = hxlistVo;
    
    _hxlistVo = [hxlistVoHouseDetial mj_objectArrayWithKeyValuesArray:_hxlistVo];
}

- (void)setZstList:(NSArray *)zstList{
    _zstList = zstList;
    
    _zstList = [zstListHousePicture mj_objectArrayWithKeyValuesArray:_zstList];
}

- (void)setNear:(NSMutableArray *)near{
    _near = near;
    _near = [HouseListModel mj_objectArrayWithKeyValuesArray:_near].mutableCopy;
}

- (void)setList:(NSMutableArray *)list{
    _list = list;
    _list = [HouseListModel mj_objectArrayWithKeyValuesArray:_list].mutableCopy;
}


- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    _lp = [lpHouseDetial mj_objectWithKeyValues:_dataDic[@"lp"]];
//    _xmbc = [xmbcHouseDetial mj_objectWithKeyValues:_dataDic[@"xmbc"]];
    _kpxm = [kpxmHouseDetial mj_objectWithKeyValues:_dataDic[@"kpxm"]];
    _ldxx = [ldxxListHouseDetial mj_objectWithKeyValues:_dataDic[@"ldxx"]];
}


//
//@property (nonatomic,copy) NSArray *zstList;//Array[24],    //展示图片  zstListHousePicture
//@property (nonatomic,copy) NSArray *hxlistVo;//Array[1],     户型列表   hxlistVoHouseDetial
//@property (nonatomic,copy) NSString *ldxxList;//Array[0],    //楼栋信息
//
////HouseListModel
//@property (nonatomic,copy) NSArray *zb;//Array[0],       周边   附近的楼盘
//@property (nonatomic,copy) NSArray *list;//Array[0],        感兴趣的人还浏览了   ..楼盘列表
@end
