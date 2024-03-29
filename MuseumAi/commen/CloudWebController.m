//
//  CloudWebController.m
//  AplusEducationPro
//
//  Created by neon on 2017/4/20.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "CloudWebController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface CloudWebController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) WKWebViewConfiguration *config;
@property (nonatomic,assign)BOOL isRecharge; //是不是悦点充值
@end

@implementation CloudWebController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRefresh) name:LOGINSUCCESS object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayState:) name:WXPayState object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayState:) name:AliPayState object:nil];
    
}
- (void)setUI{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:self.requestURL]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    
    if (@available(iOS 11.0,*)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    self.progressView.progressTintColor = kUIColorFromRGB(0xfb8a3c);
    self.progressView.trackTintColor = kUIColorFromRGB(0xb3b3b3);
    [self.view addSubview:self.progressView];
     self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(callBack)]];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.config.userContentController addScriptMessageHandler:self name:@"BanNiProject"];
    //    [self.navigationController.navigationBar setHidden:self.isHiddenNav];
    [self deleteWebCache];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.config.userContentController removeScriptMessageHandlerForName:@"BanNiProject"];
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (![ProUtils isNilOrNull:self.webView.title]) {
        self.title = self.webView.title;
    }
    
    //    NSString *jsStr = [NSString stringWithFormat:@"GetIOSUserInfo('%@')",[LoginSession sharedInstance].token];
    //    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    //        if (error) {
    //
    //        }
    //    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *dic = message.body;
    
//    if ([dic[@"operaType"] isEqualToString:@"calltel"]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dic[@"telNum"]]]];
//    }
//
//    if ([dic[@"operaType"] isEqualToString:@"login"]) {
//        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
//    }
//
//    if ([dic[@"operaType"] isEqualToString:@"pay"]) {
//        //0支付宝 1微信 H5传过来
//        //(微信支付0,支付宝3)。后台需要
//        [[NetWork shareManager] getWithUrl:DetailUrlString(@"/api/shopping/prepay") para:@{@"orderid":dic[@"orderId"],@"paymethod":@([dic[@"payMethod"] integerValue] == 0 ?3:0)} isShowHUD:YES callBack:^(id  _Nonnull response, BOOL success) {
//            if ([dic[@"payMethod"] integerValue] == 1) {
//                [self wechatPay:response[@"data"]];
//            }
//            if ([dic[@"payMethod"] integerValue] == 0) {
//                [self aliPay:response[@"data"]];
//            }
//        }];
//
//    }
//    if ([dic[@"operaType"] isEqualToString:@"share"]) {
//        [ProUtils shareActionWithURL:dic[@"url"] withTitle:dic[@"title"] withText:dic[@"desc"] image:dic[@"imgUrl"] biztype:[dic[@"bizType"] integerValue] relationid:dic[@"relateId"]];
//    }
//
//    if ([dic[@"operaType"] isEqualToString:@"map"]) {
//        [self goMapAPPWithLatitude:[dic[@"musterX"] doubleValue] longitude:[dic[@"musterY"]doubleValue] address:dic[@"address"]];
//    }
//    if ([dic[@"operaType"] isEqualToString:@"jumpurl"]) {
//        if ([dic[@"urls"] isEqualToString:@"coupon"]) {
//            [self.navigationController pushViewController:[CouponViewController new] animated:YES];
//        }
//        if ([dic[@"urls"] isEqualToString:@"service"]) {
//            CustomerServiceViewController *controller = [[CustomerServiceViewController alloc] init];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//        if ([dic[@"urls"] isEqualToString:@"point"]) {
//            MyBalanceViewController *controller = [[MyBalanceViewController  alloc] init];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//    }
//    if ([dic[@"operaType"] isEqualToString:@"paypoint"]) {
//        self.isRecharge = YES;
//        if ([dic[@"payMethod"] integerValue] == 0) { //支付宝
//            [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/alipay/charge") para:@{@"fee":dic[@"PayPrice"]} isShowHUD:YES callBack:^(id  _Nonnull response, BOOL success) {
//                if (success) {
//                    [self aliPay:response[@"data"]];
//                }
//            }];
//        }
//        if ([dic[@"payMethod"] integerValue] == 1) { //微信
//            [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/wechat/charge") para:@{@"fee":dic[@"PayPrice"]} isShowHUD:YES callBack:^(id  _Nonnull response, BOOL success) {
//                if (success) {
//                    [self wechatPay:response[@"data"]];
//                }
//            }];
//        }
//    }
//    if ([dic[@"operaType"] isEqualToString:@"signout"]) {
//        [[LoginSession sharedInstance] destroyInstance];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    if ([dic[@"operaType"] isEqualToString:@"saveorcode"]) {
//        UIImage *image = [ProUtils createQRCode:dic[@"urls"]];
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
//    if(error){
//        [self.view makeToast:@"保存失败"];
//    }else{
//        [self.view makeToast:@"保存成功"];
//    }
}

- (UIImage*)fullScreenshots{
    //    屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)deleteWebCache {
    if (@available(iOS 9.0,*)) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];  // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        NSLog(@"%@", errors);
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
}


#pragma mark getter & setter
- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        self.config = config;
        
        NSString *jsStr = [NSString stringWithFormat:@"window.BanNiProject = {requestUserInfo:function(){return '%@';}}",[LoginSession sharedInstance].token];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [config.userContentController addUserScript:script];
        
        _webView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds configuration:config];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
         [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}


- (void)payResultCallBack:(NSInteger)state{ // 0 是成功 1 失败
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"getPayOrderParams(%ld)",(long)state] completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }
    }];
}


//- (BOOL)navigationShouldPopOnBackButton{
//    if (_isGoBack && self.webView.canGoBack) {
//        [self.webView goBack];
//        return NO;
//    }
//    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"JSBridge"];
//    return YES;
//}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]) {
        NSString *title = change[NSKeyValueChangeNewKey];
        if (![ProUtils isNilOrNull:title]) {
            self.title = title;
        }
        return;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:YES];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
         [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        CGFloat offsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
        if (self.noScrollAction) {
            if (!self.scrollEnabled) {
                self.webView.scrollView.contentOffset = CGPointZero;
            }
            
            /// 当偏移量小于0时，不能滑动，并且使主要视图的UITableView滑动
            if (offsetY < 0 ) {
                self.scrollEnabled = NO;
                self.webView.scrollView.contentOffset = CGPointZero;
                if (self.noScrollAction) {
                    self.noScrollAction();
                }
            }
        }
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    if ([keyPath isEqualToString:@"canGoBack"]) {
        BOOL newCangoBack = [change[NSKeyValueChangeNewKey] boolValue];
        BOOL oldCangoBack = [change[NSKeyValueChangeOldKey] boolValue];
        if (newCangoBack != oldCangoBack) {
            if (!newCangoBack) {
                self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(callBack)]];
            } else {
                self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_nor"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)],[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"webview_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(callBack)]];
            }
        }
    }
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    
}

- (void)loginRefresh{
    NSString *jsStr = [NSString stringWithFormat:@"GetIOSUserInfo('%@')",[LoginSession sharedInstance].token];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }
    }];
}
//
//#pragma mark  --- 导航
//- (void)goMapAPPWithLatitude:(double)latitude longitude:(double)longitude address:(NSString*)address{
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [controller addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
//            NSString *urlString =[[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=0",longitude,latitude,address]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlString]];
//        } else {
//            [self.view makeToast:@"你尚未安装高德地图,请下载或用其他地图打开"];
//        }
//
//    }]];
//    [controller addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //腾讯地图
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
//            NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",longitude,latitude,address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        } else {
//            [self.view makeToast:@"你尚未安装腾讯地图,请下载或用其他地图打开"];
//        }
//    }]];
//    [controller addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
//            //中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
//            CLLocationCoordinate2D bdCoordinate = [JZLocationConverter gcj02ToBd09:CLLocationCoordinate2DMake(longitude, latitude)];
//            NSString *urlString =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=bd09ll",bdCoordinate.latitude,bdCoordinate.longitude,address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        } else {
//            [self.view makeToast:@"你尚未安装百度地图,请下载或用其他地图打开"];
//        }
//    }]];
//    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }]];
//    [self presentViewController:controller animated:YES completion:nil];
//}
- (void)callBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goBack{
    [self.webView goBack];
}
@end
