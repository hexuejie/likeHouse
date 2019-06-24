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


//1
////"sjhm": "15116164690",
////"yhbh": "A000120269",
////"yhmm": null,
////"yhzt": 0,
////"rzrq": null,
////"rzzt": 2,
////"yhxm": "杨明",
////"zjhm": "430122198910102197",
////"zjlx": "身份证"
@property (nonatomic,strong)NSString *yhzt;//状态
@property (nonatomic,strong)NSString *rzzt;//证状态（0-待审核，1,待人工审核，2-审核通过，3-审核未通过）

@property (nonatomic,copy)NSString *yhbh;
@property (nonatomic,copy)NSString *zjhm;//证件号码
@property (nonatomic,copy)NSString *zjlx;//证件类型
@property (nonatomic,copy)NSString *sjhm;//手机号




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


@end

NS_ASSUME_NONNULL_END
