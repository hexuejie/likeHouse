//
//  CloudWebController.h
//  AplusEducationPro
//
//  Created by neon on 2017/4/20.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MURootViewController.h"

@interface CloudWebController : MURootViewController
@property (nonatomic,strong) NSString *requestURL;
@property (nonatomic)BOOL isGoBack;

@property (nonatomic,assign)BOOL scrollEnabled;

@property (nonatomic,strong)WKWebView *webView;

@property (nonatomic, copy)void (^noScrollAction)(void);

@property (nonatomic, copy)void (^rechargeSuccessBlock)(void);

@end
