//
//  MyCenterAboutViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterAboutViewController.h"

@interface MyCenterAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *TitleAndVersion;

@end

@implementation MyCenterAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于悦居星城";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.TitleAndVersion.text = [NSString stringWithFormat:@"悦居星城：V%@",app_Version];
}

// 当前app的信息NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];   CFShow(infoDictionary);  // app名称NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];// app版本NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// app build版本NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//手机别名： 用户定义的名称    NSString* userPhoneName = [[UIDevice currentDevice] name];  NSLog(@"手机别名: %@", userPhoneName);//设备名称    NSString* deviceName = [[UIDevice currentDevice] systemName];  NSLog(@"设备名称: %@",deviceName );//手机系统版本    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];  NSLog(@"手机系统版本: %@", phoneVersion);//手机型号    NSString* phoneModel = [[UIDevice currentDevice] model];  NSLog(@"手机型号: %@",phoneModel );//地方型号  （国际化区域名称）    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];  NSLog(@"国际化区域名称: %@",localPhoneModel );    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];  // 当前应用名称NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];NSLog(@"当前应用名称：%@",appCurName);// 当前应用软件版本  比如：1.0.1NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];NSLog(@"当前应用软件版本:%@",appCurVersion);// 当前应用版本号码   int类型NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];NSLog(@"当前应用版本号码：%@",appCurVersionNum);

//获取APPStore里面的版本号, 可以与本地的版本号作比较,判断是否有新版本更新......NSString *urlString=@"http://itunes.apple.com/lookup?id=1295166"; //自己应用在App Store里的地址NSURL *url = [NSURL URLWithString:urlString];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];//    解析json数据id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

@end
