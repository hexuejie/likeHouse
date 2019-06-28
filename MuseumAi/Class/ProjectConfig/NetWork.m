//
//  NetWork.m
//  banni
//
//  Created by zhudongliang on 2018/11/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "NetWork.h"
#import "NSObject+null.h"
//#import "ProUtils.h"
#import <sys/utsname.h>
#import "MULoginViewController.h"

@implementation NetWork

#define KTipString @"网络请求超时"

// 需要#import <sys/utsname.h>
+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
}


+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static NetWork *netWork = nil;
    dispatch_once(&onceToken, ^{
        netWork = [[NetWork alloc] init];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
//        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"system"];
        
        //NSString *deviceName = [[UIDevice currentDevice] name];  //获取设备名称 例如：梓辰的手机
       // NSString *sysVersion = [[UIDevice currentDevice] systemName]; //获取系统名称 例如：iPhone OS
        //NSString *sysVersion = [[UIDevice currentDevice] systemVersion]; //获取系统版本 例如：9.2
       // NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
        //NSString *deviceModel = [[UIDevice currentDevice] model]; //获取设备的型号 例如：iPhone
        
//        NSString *deviceModel = [NetWork deviceModelName];
//        [manager.requestSerializer setValue:deviceModel forHTTPHeaderField:@"phonemodel"];
//        [manager.requestSerializer setValue:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"version"];
//        [manager.requestSerializer setValue:@"eyJhbGciOiJSUzI1NiIsImtp" forHTTPHeaderField:@"password"];
//        [manager.requestSerializer setValue:@"alByN3hhNFlTUnlCZEdHMGtsbXolMkJnJTNEJTNEOmU3NHNEYXczZUklMkZLQnliN2VKbHVZUSUzRCUzRA" forHTTPHeaderField:@"token"];
//        token=
        manager.requestSerializer.timeoutInterval = 20;
        
        netWork.manager = manager;
    });
    return netWork;
}
- (void)postWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD callBack:(void (^)(id response, BOOL success))callBack{
    [self postWithUrl:urlString para:para isShowHUD:isShowHUD isToLogin:YES callBack:^(id response, BOOL success) {
        callBack(response,success);
    }];
}
- (void)getWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD callBack:(void (^)(id response, BOOL success))callBack{
    [self getWithUrl:urlString para:para isShowHUD:isShowHUD isToLogin:YES callBack:^(id response, BOOL success) {
        callBack(response,success);
    }];
}

- (void)postWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD isToLogin:(BOOL)isTologin callBack:(void (^)(id response, BOOL success))callBack{

   

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSArray* headerCookie = [[NSUserDefaults standardUserDefaults]objectForKey:@"Cookie"];
    if (headerCookie.count && isTologin) {
        NSString *strstr = @"";
        for (NSDictionary *temptemp in headerCookie) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:temptemp]];
        }
    }else{
        if (isTologin) {
            [self toLogin];
            return;
        }
    }

        [manager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
            
            NSDictionary* responseDict;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                responseDict = responseObject;
            }else{
               responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            }
         
        NSInteger resultCode = [responseDict[@"code"] integerValue];
        
        // 2 token错误 3 token 过期 401 未授权
        if (resultCode == 0) {
            if (isTologin) {
//                [[LoginSession sharedInstance] destroyInstance];
                 [self toLogin];
            }
            return ;
        }
        if (resultCode == 200) {
            callBack([responseDict removeNull],YES);
            return ;
        } else {
            callBack(responseDict,NO);
            [SVProgressHelper dismissWithMsg:[NSString stringWithFormat:@"%@",responseDict[@"error"]]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
            if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                
                // 错误码
                NSInteger code = [response[@"code"] integerValue];
                if( code == 401) {
                    if (isTologin) {
//                        [[LoginSession sharedInstance] destroyInstance];
                        [self toLogin];
                    }
                } else {
                    callBack(nil,NO);
                    [SVProgressHelper dismissWithMsg:KTipString];
                }
            } else {
                callBack(nil,NO);
                    [SVProgressHelper dismissWithMsg:KTipString];
            }
        });
    }];
}


- (void)getWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD isToLogin:(BOOL)isTologin callBack:(void (^)(id response, BOOL success))callBack{
    
//    if (isShowHUD) {
//        [SVProgressHUD show];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    }
    
    [[NetWork shareManager].manager GET:urlString parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSInteger resultCode = [responseDict[@"code"] integerValue];
        
//        DLog(@"%@",responseDict);
        // 2 token错误 3 token 过期 401 未授权
        if (resultCode == 3 || resultCode == 401) {
            if (isTologin) {
//            [[LoginSession sharedInstance] destroyInstance];
                [self toLogin];
            }
            return ;
        }
        
        if (resultCode == 0) {
            callBack([responseDict removeNull],YES);
            return ;
        } else {
            callBack(responseDict,NO);
//            [[UIApplication sharedApplication].keyWindow hideToasts];
//            [[UIApplication sharedApplication].keyWindow makeToast:responseDict[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
            if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                
                // 错误码
                NSInteger code = [response[@"code"] integerValue];
                if( code == 401) {
//                     [[LoginSession sharedInstance] destroyInstance];
                    if (isTologin) {
                        [self toLogin];
                    }
                } else {
                    callBack(nil,NO);
//                    [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求超时"];
                }
            } else {
                callBack(nil,NO);
//                [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求超时"];
            }
            
            
    
        });
    }];
}




- (void)postFormDataWithUrl:(NSString *)urlString para:(id)para isShowHUD:(BOOL)isShowHUD images:(NSArray*)images isIncludeGif:(BOOL)isIncludeGif callBack:(void (^)(id response, BOOL success))callBack{
    
//    if (isShowHUD) {
//        [SVProgressHUD show];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    }
    [[NetWork shareManager].manager POST:urlString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSInteger resultCode = [responseDict[@"code"] integerValue];
        
        NSLog(@"%@",responseDict);
        // 2 token错误 3 token 过期 401 未授权
        if (resultCode == 2|| resultCode == 103 || resultCode == 401) {
            [self toLogin];
            return ;
        }
        
        if (resultCode == 200) {
            callBack([responseDict removeNull],YES);
            return ;
        } else {
            callBack(responseDict,NO);
//            [[UIApplication sharedApplication].keyWindow makeToast:responseDict[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
            
            // 错误码
            NSInteger code = [response[@"code"] integerValue];
            if( code == 401) {
                [self toLogin];
            } else {
                callBack(nil,NO);
//                [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求超时"];
            }
        } else {
            callBack(nil,NO);
//            [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求超时"];
        }
    }];
}
- (void)toLogin{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //登录
        MULoginViewController *loginController = [[MULoginViewController alloc] init];
        [[ProUtils getCurrentVC] presentViewController:loginController animated:YES completion:nil];
    });
}


+ (void)uploadMoreFileHttpRequestURL:(NSString *)url  RequestPram:(id)pram arrayImg:(NSArray *)arrayImg arrayAudio:(NSArray *)arrayAudio RequestSuccess:(void(^)(id respoes))success RequestFaile:(void(^)(NSError *erro))faile UploadProgress:(void(^)(NSProgress * uploadProgress))progress{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:pram constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        ///用时间设置文件名
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyyMMddhhmmss"];
        
        NSString *dateNow = [formatter stringFromDate:date];
        
        
        
        NSString *imgFileId = @"handsomekkImg";
        
        //  NSString *avdioFileId = @"ebookAvdio";
        
        ///图片文件data追加
        
        for (int i = 0; i < arrayImg.count; i++) {
            
//            ///文件名：这是多个文件名不一样，多以我就用i实现
//
//            NSString *fileName = [NSString stringWithFormat:@"%@%@%d.png",imgFileId,dateNow,i];
//
//            ///图片支持类型jpg/png/jpeg
//
//            [formData appendPartWithFileData:arrayImg[i] name:[NSString stringWithFormat:@"%@%d",imgFileId,i] fileName:fileName mimeType:@"jpg/png/jpeg"];
            
            NSData *data = UIImageJPEGRepresentation(arrayImg[i], 0.8);
            [formData appendPartWithFileData:data name:@"file" fileName:@".jpg" mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        ///进度回调
        
//        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ///上传功能回调
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        if (success&& [responseDict[@"code"] integerValue] == 200) {
            
            success(responseDict[@"data"]);
            
        }else{
             [SVProgressHelper dismissWithMsg:[NSString stringWithFormat:@"%@",responseDict[@"error"]]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        ///失败回调
        [SVProgressHelper dismissWithMsg:@"上传图片出错"];
        faile(error);
        
    }];
    
}

@end
