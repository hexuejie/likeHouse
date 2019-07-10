//
//  ZTDetialViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/9.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "ZTDetialViewController.h"
#import "QuestionListTableViewCell.h"
#import "CloudWebController.h"
#import "QuestionDetialViewController.h"

@interface ZTDetialViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;



@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ZTDetialViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"QuestionListTableViewCell"];
    //    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCenterLoginOutTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyCenterLoginOutTableViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    self.webView.delegate = self;
//    self.tableView.tableHeaderView = self.webView;
    [self.view addSubview:self.webView];
    
    

    [self.webView loadHTMLString:[self adaptWebViewForHtml:[NSString stringWithFormat:@"%@",_formatString]] baseURL:nil];
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.backgroundColor = kUIColorFromRGB(0xF1F1F1);
}

//- (void)webViewDidFinishLoad:(UIWebView*)webView{
//    CGFloat heightWeb = [self.webView.scrollView contentSize].height;
//    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, heightWeb+10);
//    self.tableView.scrollEnabled = YES;
//    self.tableView.tableHeaderView = self.webView;
//
////    [self.tableView reloadData];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        
//        CGFloat heightWeb = [self.webView.scrollView contentSize].height;
//        self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, heightWeb+10);
//        self.tableView.scrollEnabled = YES;
////        [self.tableView reloadData];
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionListTableViewCell" forIndexPath:indexPath];
    
    [cell.orderButton setTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1] forState:UIControlStateNormal];
    cell.contentLabel.text = _dataArray[indexPath.row][@"wtbt"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionDetialViewController *vc = [QuestionDetialViewController new];
    vc.title = @"问题详情";
    vc.dataDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 17.0;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (void)reloadData{
    
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(@"/api/family/xf/user/questions") para:@{} isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            weakSelf.dataArray = response[@"data"];
            //            weakSelf.detialModel.dataDic = response[@"data"];
            
//            [weakSelf.tableView reloadData];
//            if (weakSelf.dataArray.count == 0) {
//                [weakSelf addNoneDataTipView];
//            }
        }else{
        }
    }];
}



- (void)webViewDidStartLoad:(UIWebView*)webView{
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '260%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#444444'"];
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

//- (void)dealloc{
//
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
//}
@end
