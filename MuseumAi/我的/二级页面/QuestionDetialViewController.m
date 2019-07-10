//
//  QuestionDetialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/2.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "QuestionDetialViewController.h"

@interface QuestionDetialViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation QuestionDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"问题详情";
    
    self.titleLabel.text = _dataDic[@"wtbt"];
//    NSString *strstr = _dataDic[@"wtms"];
    NSString * formatString = [NSString stringWithFormat:@"<span style=\"font-size:14px;color:#808080\">%@</span>",_dataDic[@"wtms"]];
    [self.webView loadHTMLString:[self adaptWebViewForHtml:formatString] baseURL:nil];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;//设置webview不可滚动，让tableview本身滚动即可
    self.webView.scrollView.bounces = NO;
    
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
}

- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\" color=\"#FF0000\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=false\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    

    
    //适配图片宽度，如果图片宽度超过手机屏幕宽度，就让图片宽度等于手机屏幕宽度，高度自适应，如果图片宽度小于屏幕宽度，就显示图片大小
    [headHtml appendString : @"<script type='text/javascript'>"
     "window.onload = function(){\n"
     "var maxwidth=document.body.clientWidth-30;\n" //屏幕宽度
     "for(i=0;i <document.images.length;i++){\n"
     "var myimg = document.images[i];\n"
     "if(myimg.width > maxwidth){\n"
     "myimg.style.width = '97%';\n"
     "myimg.style.height = 'auto'\n;"
     "}\n"
     "}\n"
     "}\n"
     "</script>\n"];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    [headHtml appendString : @"<title>webview</title>" ];
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}


//- (void)webViewDidStartLoad:(UIWebView*)webView{
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'";
//    [webView stringByEvaluatingJavaScriptFromString:str];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#444444'"];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView*)webView{
//    //    [self.tableView reloadData];
//    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //        _heightWeb = [webView.scrollView contentSize].height;
//    //        _cell.labelBottom.constant = _heightWeb+10;
//    //        [self.tableView reloadData];
//    //    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _heightWeb = [webView.scrollView contentSize].height;
//        _cell.labelBottom.constant = _heightWeb+10;
//        [self.tableView reloadData];
//    });
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        _heightWeb = [self.web.scrollView contentSize].height;
//        _cell.labelBottom.constant = _heightWeb+10;
//        self.tableView.scrollEnabled = YES;
//        [self.tableView reloadData];
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
@end
