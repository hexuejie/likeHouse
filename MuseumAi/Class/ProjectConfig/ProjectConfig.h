//
//  ProjectConfig.h
//  banni
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef ProjectConfig_h
#define ProjectConfig_h


#endif /* ProjectConfig_h */

#define UserSchoolInfo @"UserSchoolInfo"
#define HistoryTag @"HistoryTag"
#define WXPaySuccess @"WXPaySuccess"
#define WXPayFail @"WXPayFail"
#define WXPayState @"WXPayState"
#define WXWXPayCancel @"WXWXPayCancel"
#define ChangeSchoolSuccess @"ChangeSchoolSuccess"
#define DestroyUserInfo @"DestroyUserInfo"

#define AliPaySuccess @"AliPaySuccess"
#define AliPayFail @"AliPayFail"
#define AliPayState @"AliPayState"

#define ReceiveCustomSystemNotification @"ReceiveCustomSystemNotification"
#define BlacklistPostNOtification @"BlacklistPostNOtification"
#define BlacklistPostList @"BlacklistPostList"
#define TaglistHisList @"TaglistHisList"

#define WashClothesShopCartDeleteProduct @"WashClothesShopCartDelegateProduct"
#define WashClothesShopCartProductNumberIsChange @"WashClothesShopCartProductNumberIsChange"

#if 0 //测试环境开关
#define BaseUrl @"http://192.168.0.199:91"
#define H5BaseUrl @"http://192.168.0.199:94"
#else
#define BaseUrl @"https://api1.bnbn99.com"
#define H5BaseUrl @"https://appweb.bnbn99.com"
#endif

#define DetailUrlString(string) [NSString stringWithFormat:@"%@%@",BaseUrl,string]

//Http配置
#define kHttpServerAddr @"http://license.vod2.myqcloud.com/license/v1/" //腾讯云

#define H5DetailUrlString(string) [NSString stringWithFormat:@"%@%@?from=ios",H5BaseUrl,string]

#define WXAPPID @"wx478bde8f16b6c1c4"
#define WXAPPSecret @"df4930f6ebcce738585f1ed81404d6fe"

#define QQAPPID @"101521020"
#define QQAPPKEY @"f303305e9ad60fbbc50b98329a8b32ad"

#define MAPAPPKEY @"21268df126c95962235c84ffe99654e4"

#define umengappkey @"5bdfd979f1f556528e00047c"

#define LOGINSUCCESS  @"LoginSuccess"

#define DBPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/shopCart.db"]
#define TIMEOUT 60
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define NavBarTopHeight (kStatusBarHeight + kNavBarHeight) //navgationBar高度
#define KBottomSafeDistance ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define fitscale2x(args) floor(((int)((SCREEN_WIDTH/375.0*(args))*1000))/1000.0)

//#define UIColorFromRGB(rgbValue, alphaValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue])

#define textFont(args)  [UIFont systemFontOfSize:args]
#ifdef DEBUG
# define DLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif
