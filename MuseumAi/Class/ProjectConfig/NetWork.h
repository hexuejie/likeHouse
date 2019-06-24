//
//  NetWork.h
//  banni
//
//  Created by zhudongliang on 2018/11/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "ImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetWork : NSObject

+ (instancetype)shareManager;
//+ (NSString *)deviceModelName;

@property (nonatomic,strong)AFHTTPSessionManager *manager;

- (void)postWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD callBack:(void (^)(id response, BOOL success))callBack;

- (void)getWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD callBack:(void (^)(id response, BOOL success))callBack;

- (void)getWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD isToLogin:(BOOL)isTologin callBack:(void (^)(id response, BOOL success))callBack;

- (void)postWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD isToLogin:(BOOL)isTologin callBack:(void (^)(id response, BOOL success))callBack;

//- (void)postFormDataWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD images:(NSArray*)images callBack:(void (^)(id response, BOOL success))callBack;

- (void)postFormDataWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD images:(NSArray*)images isIncludeGif:(BOOL)isIncludeGif callBack:(void (^)(id response, BOOL success))callBack;


+ (void)uploadMoreFileHttpRequestURL:(NSString *)url  RequestPram:(id)pram arrayImg:(NSArray *)arrayImg arrayAudio:(NSArray *)arrayAudio RequestSuccess:(void(^)(id respoes))success RequestFaile:(void(^)(NSError *erro))faile UploadProgress:(void(^)(NSProgress * uploadProgress))progress;
@end

NS_ASSUME_NONNULL_END
