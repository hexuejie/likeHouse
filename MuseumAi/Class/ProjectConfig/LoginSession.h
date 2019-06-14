//
//  LoginSession.h
//  banni
//
//  Created by zhudongliang on 2018/11/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AddressInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginSession : NSObject<NSCoding>

+ (instancetype)sharedInstance;

- (void)destroyInstance;

- (BOOL)isLogin;

@property (nonatomic,assign)NSInteger pageType;//0实名认证   1配偶    2子女

@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *token;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSString *nickName;

@property (nonatomic,copy)NSString *introduct;

@property (nonatomic,copy)NSString *headImg;

//@property (nonatomic,strong)AddressInfo *addressInfo;

@property (nonatomic,strong)NSNumber *userId;

@property (nonatomic,strong)NSString *guidelink; //生成二维码

@property (nonatomic,strong)NSNumber *schoolId;

@property (nonatomic,strong)NSString *schoolname;

@property (nonatomic,strong)NSString *lstTagName;

@property (nonatomic,assign)BOOL isHasUnreadMessage;

@property (nonatomic,assign)BOOL isBindQQ;

@property (nonatomic,assign)BOOL isBindWeChat;
@property (nonatomic,strong)NSString *createTime;


@property (nonatomic,strong)NSString *yhzt;//状态

@property (nonatomic,strong)NSString *rzzt;

@end

NS_ASSUME_NONNULL_END
