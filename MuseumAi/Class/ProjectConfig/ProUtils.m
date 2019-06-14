//
//  ProUtils.m
//  banni
//
//  Created by zhudongliang on 2018/11/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ProUtils.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
#import <MapKit/MapKit.h>
#import <CoreImage/CoreImage.h>
//#import <NIMKit.h>
//#import <ShareSDKUI/ShareSDKUI.h>
//#import <NIMSDK/NIMSDK.h>
//#import "PersonHomePageViewController.h"
//#import "CouponViewController.h"
//#import "TopicPostViewController.h"
//#import "MyBalanceViewController.h"
//#import "SchoolWashClothesController.h"
//#import "CloudWebController.h"
//#import "MULoginViewController.h"
//#import "NTESSessionViewController.h"
//#import "BaseNavigationViewController.h"
//#import "ImageModel.h"
#import <Photos/Photos.h>

@implementation ProUtils

+ (BOOL)isNilOrNull:(id)obj{
    if ([obj isKindOfClass:[NSNull class]] || !obj) {
        return YES;
    } else if ([obj isKindOfClass:[NSString class]] && [[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)safeString:(NSString *)string {
    if (!string || [string isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return string;
    }
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if([ProUtils isNilOrNull:mobileNum]){
        return NO;
    }
    
    
    if(mobileNum.length != 11){
        return NO;
    }
    
    NSString *regex = @"^\\d{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:mobileNum];
    if(!isValid){
        return NO;
    }
    
    return YES;
}

+ (void)setsession:(LoginSession *)session{
    [self archiveSession:session];
}

+ (void)archiveSession:(LoginSession*)session {
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *sessionpath = [filepath stringByAppendingPathComponent:@"session.archive"];
    [NSKeyedArchiver archiveRootObject:session toFile:sessionpath];
}

+ (LoginSession*)unarchiverSession {
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *sessionpath = [filepath stringByAppendingPathComponent:@"session.archive"];
    LoginSession *session = [NSKeyedUnarchiver unarchiveObjectWithFile:sessionpath];
    //    NSLog(@" token-----  %@",session.token);
    //    if ([ProUtils isNilOrNull:session.phone]) {
    //        return nil;
    //    }
    return session;
}

+ (void)removeSession {
    NSString *filepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *sessionpath = [filepath stringByAppendingPathComponent:@"session.archive"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:sessionpath error:nil];
}

+ (NSString *) encryptUseDES:(NSString *)plainText
{
    NSString *key = @"cyxysqoy";
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          textBytes,
                                          dataLength,
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

+ (CGSize)computeSizeWithString:(NSString *)text attribute:(NSDictionary *)attribute maxSize:(CGSize)maxSize{
    return [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil].size;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
    //    UIViewController *result = nil;
    //
    //    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //    if (window.windowLevel != UIWindowLevelNormal)
    //    {
    //        NSArray *windows = [[UIApplication sharedApplication] windows];
    //        for(UIWindow * tmpWin in windows)
    //        {
    //            if (tmpWin.windowLevel == UIWindowLevelNormal)
    //            {
    //                window = tmpWin;
    //                break;
    //            }
    //        }
    //    }
    //    UIView *frontView = [[window subviews] objectAtIndex:0];
    //    id nextResponder = [frontView nextResponder];
    //
    //    if ([nextResponder isKindOfClass:[UIViewController class]])
    //        result = nextResponder;
    //    else
    //        result = window.rootViewController;
    //    if ([result isKindOfClass:[UINavigationController class]]) {
    //        result = ((UINavigationController*)result).topViewController;
    //    }
    //    if ([result isKindOfClass:[UITabBarController class]]) {
    //        result = ((UINavigationController*)((UITabBarController*)result).selectedViewController).topViewController;
    //    }
    //
    //    return result;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
//    CGRect rect = CGRectMake(0, 0, 1, 0.5);
//    // Create a 1 by 1 pixel context
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//    [color setFill];
//    UIRectFill(rect);   // Fill it with your color
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return image;
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开始画图的上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 设置背景颜色
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}
//view转成image
+ (UIImage*)imageWithUIView:(UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}

+ (NSString*)hidePhone:(NSString*)phone{
    if (phone.length > 7) {
        NSString *string = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return string;
    }
    return phone;
}
+ (NSString*)dealTiem:(NSString*)time{
    long seconds = [[NSDate date] timeIntervalSince1970] - [time longLongValue];
    NSString *newtime;
    if (seconds < 0) {
        newtime = @"未知的时间";
    } else if (seconds < 1) {
         newtime = @"刚刚";
    }
    else if (seconds < 60) {
        newtime = [NSString stringWithFormat:@"%ld秒前",(long)seconds];
    } else if (seconds < 3600) {
        newtime = [NSString stringWithFormat:@"%ld分钟前",seconds/60];
    } else if (seconds < 3600*24){
        newtime = [NSString stringWithFormat:@"%ld小时前",seconds/3600];
    } else if (seconds < 3600*24*30) {
        newtime = [NSString stringWithFormat:@"%ld天前",seconds/(3600*24)];
    } else if (seconds < 3600*24*365)  {
        newtime = [NSString stringWithFormat:@"%ld个月前",seconds/(3600*24*30)];
    } else {
        newtime = [NSString stringWithFormat:@"%ld年前",seconds/(3600*24*365)];
    }
    return newtime;
}
+ (BOOL)checkLocation {
    //确定用户的位置服务是否启用,位置服务在设置中是否被禁用
    BOOL enable      =[CLLocationManager locationServicesEnabled];
    NSInteger status =[CLLocationManager authorizationStatus];
    if(  !enable ){
        //尚未授权位置权限
        return YES ; //继续使用 会有系统提示
    }else{
        if (status == kCLAuthorizationStatusDenied) {
            //拒绝使用位置
            return NO;
        }else{
            return YES;
        }
    }
}

+ (UIImage*)createQRCode:(NSString *)url{
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/帐号和密码) -- 通过KVC设置过滤器,只能设置NSData类型
    NSString *dataString = url;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *image = [filter outputImage];
    
    //获得清楚二维码
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(200/CGRectGetWidth(extent), 200/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//+ (void)shareWithTitle:(NSString*)title images:(NSArray *)images content:(NSString *)content url:(NSString *)url platformType:(SSDKPlatformType)type arcId:(NSString*)arcId{
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:content images:images url:[NSURL URLWithString:url] title:title type:SSDKContentTypeAuto];
//
//    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        NSInteger sharetype = 0;
//        if (type == SSDKPlatformTypeQQ) {
//            sharetype = 3;
//        }
//        if (type == SSDKPlatformSubTypeQZone) {
//            sharetype = 4;
//        }
//        if (type == SSDKPlatformTypeWechat) {
//            sharetype = 0;
//        }
//        if (type == SSDKPlatformSubTypeWechatTimeline) {
//            sharetype = 1;
//        }
//        if (state == SSDKResponseStateSuccess) {
//            [[UIApplication sharedApplication].keyWindow makeToast:@"分享成功"];
//            [ProUtils shareCallBackWithShareType:sharetype biztype:3 relationid:arcId];
//        }
//    }];
//}
//+ (void)sendMessage:(NSNumber *)userId{
//    // 构造出具体会话
//    NIMSession *session = [NIMSession session:userId.description type:NIMSessionTypeP2P];
//    // 构造出具体消息
//    NIMMessage *message = [[NIMMessage alloc] init];
//    message.text        = @"我关注了你";
//    // 错误反馈对象
//    NSError *error = nil;
//    // 发送消息
//    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:&error];
//    if (error) {
//
//    }
//}
////商城商品分享1,商城商店分享2,帖子3
//+ (void)shareActionWithURL:(NSString *)shareurl withTitle:(NSString *)title withText:(NSString *)text image:(id)image biztype:(NSInteger)biztype relationid:(NSString *)relationid{
//    //1、创建分享参数
//    NSArray* imageArray;
//    if (image) {
//        imageArray = image;
//    } else {
//        imageArray = @[[UIImage imageNamed:@"about"]];
//    }
//    
//    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:text
//                                         images:imageArray
//                                            url:[NSURL URLWithString:shareurl]
//                                          title:title
//                                           type:SSDKContentTypeAuto];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)]
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {    NSInteger sharetype = 0;
//                               if (platformType == SSDKPlatformTypeQQ) {
//                                   sharetype = 3;
//                               }
//                               if (platformType == SSDKPlatformSubTypeQZone) {
//                                   sharetype = 4;
//                               }
//                               if (platformType == SSDKPlatformSubTypeWechatTimeline) {
//                                   sharetype = 1;
//                               }
//                               if (platformType == SSDKPlatformTypeWechat) {
//                                   sharetype = 0;
//                               }
//                               if (state == SSDKResponseStateSuccess) {
//                                   [[UIApplication sharedApplication].keyWindow makeToast:@"分享成功"];
//                                   [ProUtils shareCallBackWithShareType:sharetype biztype:biztype relationid:relationid];
//                               }
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//    
//}
/////商城商品分享1,商城商店分享2,帖子3
//+ (void)shareCallBackWithShareType:(NSInteger)shareType biztype:(NSInteger)biztype relationid:(NSString*)relationid{
//    [[NetWork shareManager] getWithUrl:DetailUrlString(@"/api/sys/sharecallback") para:@{@"biztype":@(biztype),@"relationid":relationid,@"sharetype":@(shareType),@"shareClient":@2} isShowHUD:NO callBack:^(id  _Nonnull response, BOOL success) {
//        
//    }];
//}
//
//+ (void)clickModelWithJumpType:(NSInteger)jumpType relateId:(NSString *)relationId h5Url:(NSString *)h5Url{
//    switch (jumpType) {
//        case 0:
//            //不处理
//            break;
//        case 1:{
//            PersonHomePageViewController *controller = [[PersonHomePageViewController alloc] init];
//            controller.userId = [NSNumber numberWithInteger:[relationId integerValue]];
//            [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 2:{
//            CouponViewController *controller = [[CouponViewController alloc] init];
//            [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//        }
//            break;
////        case 3:
////            //不处理
////            break;
//        case 4:{
//            TopicPostViewController *controller = [[TopicPostViewController alloc] init];
//            TopicInfo *info = [[TopicInfo alloc] init];
//            info.topicId = relationId;
//            controller.topicInfo = info;
//            [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 5:{
//            MyBalanceViewController *controller = [[MyBalanceViewController alloc] init];
//             [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 6:{
//            SchoolWashClothesController *controller = [[SchoolWashClothesController alloc] init];
//            controller.currentCategoryId = [NSNumber numberWithInteger:[relationId integerValue]];
//            [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 7:{
//            if (![ProUtils isNilOrNull:relationId]) {
//                NTESSessionViewController *controller = [[NTESSessionViewController alloc] initWithSession:[NIMSession session:relationId.description type:NIMSessionTypeP2P]];
//                [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//                
//            } else {
//            ((UITabBarController*)[UIApplication sharedApplication].delegate.window.rootViewController).selectedIndex = 2;
//            }
//        }
//            break;
//        case 10:{
//            CloudWebController *controller = [[CloudWebController alloc] init];
//            controller.requestURL = h5Url;
//            [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
//        }
//            //不处理
//            break;
//        case 99: {
//            MULoginViewController *loginController = [[MULoginViewController alloc] init];
//            UINavigationController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:loginController];
//            [[ProUtils getCurrentVC] presentViewController:nav animated:YES completion:nil];
//        }
//            
//        default:
//            break;
//    }
//}

@end
