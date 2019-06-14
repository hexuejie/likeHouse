//
//  AdModel.h
//  007
//
//  Created by zhudongliang on 2018/4/10.
//  Copyright © 2018年 zdl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdModel : NSObject


@property (nonatomic,copy)NSString *bh;
@property (nonatomic,copy)NSString *img;
//banner

@property (nonatomic,copy)NSString *linkUrl;
@property (nonatomic,copy)NSString *xmmc;
@property (nonatomic,copy)NSString *px;
@property (nonatomic,copy)NSString *xmbh;
@property (nonatomic,copy)NSString *sfxs;


//专题
@property (nonatomic,copy)NSString *ztmc;//"金地铂悦 韶山南 双地铁",
@property (nonatomic,copy)NSString *fbt;

@property (nonatomic,copy)NSString *zd;//1
@property (nonatomic,copy)NSString *ztnr;
@property (nonatomic,copy)NSString *tgbt;
@property (nonatomic,copy)NSString *tjsj;//时间
@property (nonatomic,copy)NSString *sfsc;//收藏


//楼盘
@property (nonatomic,copy)NSString *tempId;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *area;//1
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *province;//"湖南省",
@property (nonatomic,copy)NSString *jj;//价格

@property (nonatomic,copy)NSString *lpzt;//开盘待定
@property (nonatomic,copy)NSString *lplx;//住宅、公寓",
@property (nonatomic,copy)NSArray *image;


@property (nonatomic,copy)NSString *hxmjmax;
@property (nonatomic,copy)NSString *hxmjmin;
@property (nonatomic,copy)NSString *sfxsrc;
@property (nonatomic,copy)NSString *lpbh;//"映客龙湖·璟翠中心",
@property (nonatomic,copy)NSString *bq;//"繁华地段,人车分流",   标签



//"kprq": "",
//"kpsj": "",
//"kpjsrq": "",
//"kpjssj": "",
//"lpzt": "开盘待定",
//"zjmj": "",
//"lplx": "住宅、公寓",
//"sjgqj": "",
//"image": ["/2019/05/27/155891640525226880927789205022929587.jpg", "/2019/05/27/155891641188180631127789211651559880.jpg", "/2019/05/27/155891640870596781427789208475582849.jpg"],
//"hxmjmax": "142",
//"hxmjmin": "113",
//"sfxsrc": "",
//"lpbh": "WKP000000046",



//"newuser": {
//    "yhbh": "A000508129",
//    "sjhm": "18867217068",
//    "yhmm": "",
//    "yhxm": "蔡怡君",
//    "zjlx": "身份证",
//    "zjhm": "430725199803143969",
//    "rzzt": 2,
//    "rzrq": "2019-05-27",
//    "yhzt": 0
//},
//"zgsc": null,
//"gr": {
//    "jtlh": "J0243809",
//    "yhbh": "A000508129",
//    "xm": "蔡怡君",
//    "zjlx": "身份证",
//    "zjhm": "430725199803143969",
//    "qtzjlx": "",
//    "qtzjhm": "",
//    "lxdh": "18867217068",
//    "xb": "女",
//    "sfzcr": "是",
//    "jtgx": "",
//    "hyzk": "未婚",
//    "lysj": "",
//    "hjlx": "居民户口簿",
//    "hjfl": "家庭户口",
//    "hjszd": "湖南省常德市桃源县",
//    "qrrq": "",
//    "rwrq": "",
//    "twbz": "",
//    "sbrq": "",
//    "rzrq": "2019-05-27",
//    "rzzt": 1,
//    "rzbz": "本省外地户籍,社保未满24个月,首次参保:",
//    "dq": "",
//    "hzcs": null,
//    "gj": "",
//    "sftsrc": "",
//    "sfjr": "",
//    "sfzsjt": "",
//    "fydq": "",
//    "szssb": "",
//    "qtzjyxq": "20140413-20240413",
//    "qtzjcsrq": "1998-03-14",
//    "rwd": "",
//    "tsrclx": "",
//    "zcgzlssc": "",
//    "zsbasj": "",
//    "sfyfyq": ""
//}
@end
