//
//  ProUtils.h
//  banni
//
//  Created by zhudongliang on 2018/11/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginSession.h"
//#import <ShareSDK/ShareSDK.h>
//#import "Admodel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProUtils : NSObject

+ (BOOL)isNilOrNull:(id)obj;

+ (NSString *)safeString:(NSString *)string;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (void)setsession:(LoginSession*)session;

+ (void)archiveSession:(LoginSession*)session;

+ (LoginSession*)unarchiverSession;

+ (void)removeSession;

+ (NSString *) encryptUseDES:(NSString *)plainText;

+ (CGSize)computeSizeWithString:(NSString*)text attribute:(NSDictionary*)attribute maxSize:(CGSize)maxSize;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;


+ (UIImage *)imageWithColor:(UIColor *)color;

//创建这个Label的时候，frame，font，cornerRadius要设置成所生成的图片的3倍，也就是说要生成一个三倍图，否则生成的图片会虚，同学们可以试一试。
+ (UIImage*)imageWithUIView:(UIView*)view;

+ (NSString*)hidePhone:(NSString*)phone;

+ (NSString*)dealTiem:(NSString*)time;

+ (BOOL)checkLocation;

+ (UIImage *)createQRCode:(NSString *)url;

//+ (void)shareWithTitle:(NSString*)title images:(NSArray *)images content:(NSString *)content url:(NSString *)url platformType:(SSDKPlatformType)type arcId:(NSString*)arcId;

+ (void)shareActionWithURL:(NSString *)shareurl withTitle:(NSString *)title withText:(NSString *)text image:(id)image biztype:(NSInteger)biztype relationid:(NSString *)relationid;

+ (void)shareCallBackWithShareType:(NSInteger)shareType biztype:(NSInteger)biztype relationid:(NSString*)relationid;

//+ (void)sendMessage:(NSNumber *)userId;

//jumpType; //不跳转 = 0,个人主页 = 1,卡券中心 = 2,任务详情 = 3,话题主页 = 4,充值 = 5,悦洗坊 = 6, 聊天界面= 7 H5跳转 = 10
//+ (void)clickModelWithJumpType:(NSInteger)jumpType relateId:(NSString *)relationId h5Url:(NSString *)h5Url;
@end

NS_ASSUME_NONNULL_END
