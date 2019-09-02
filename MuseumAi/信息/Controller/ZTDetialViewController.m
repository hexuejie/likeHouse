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
#import "ZTDetialHeadView.h"
#import "ZTDetialBottomView.h"
#import "HouseListModel.h"
#import "HouseDetialViewController.h"

@interface ZTDetialViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) HouseListModel *gllpModel;



@property (strong, nonatomic) ZTDetialHeadView *headerView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) ZTDetialBottomView *boomshowView;
@end

@implementation ZTDetialViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kListBgColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionListTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"QuestionListTableViewCell"];
    //    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCenterLoginOutTableViewCell class])  bundle:nil] forCellReuseIdentifier:@"MyCenterLoginOutTableViewCell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.delegate = self;
//    self.tableView.tableHeaderView = self.webView;
    [self.view addSubview:self.webView];
    
    

    [self.webView loadHTMLString:[self adaptWebViewForHtml:[NSString stringWithFormat:@"%@",_formatString]] baseURL:nil];
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
     self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

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
    if (_urlString.length == 0) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[NetWork shareManager] postWithUrl:DetailUrlString(_urlString) para:_pramDic isShowHUD:YES  callBack:^(id  _Nonnull response, BOOL success) {
//        [weakSelf loadingPageWidthSuccess:success];
        if (success) {
            NSDictionary *tempData = response[@"data"];
            weakSelf.formatString = tempData[@"zt"][@"ztnr"];
            weakSelf.formatDic = tempData[@"zt"];
            if (tempData[@"zt"][@"ztnr"] == nil) {
                weakSelf.formatString = tempData[@"xw"][@"nr"];
                weakSelf.formatDic = tempData[@"xw"];
                if (tempData[@"xw"][@"nr"] == nil) {
                    weakSelf.formatString = tempData[@"nr"];
                    weakSelf.formatDic = tempData;
                }
            }
//            NSLog(@"tempData %@",tempData);
//            [weakSelf.webView loadHTMLString:[NSString stringWithFormat:@"%@",weakSelf.formatString] baseURL:nil];
            NSString *strTitle = weakSelf.formatDic[@"title"];
            NSString *strTime = weakSelf.formatDic[@"publishdate"];
            if (strTitle == nil) {
                strTitle = weakSelf.formatDic[@"bt"];
            }
            if (strTitle == nil) {
                strTitle = weakSelf.formatDic[@"tgbt"];
            }
            if (strTime == nil) {
                strTime = weakSelf.formatDic[@"fbsj"];
            }
            if (strTime == nil) {
                strTime = weakSelf.formatDic[@"tjsj"];
            }
            if (strTime == nil) {
                strTime = weakSelf.formatDic[@"sj"];
            }
            weakSelf.gllpModel = [HouseListModel mj_objectWithKeyValues: [tempData[@"gllp"] firstObject]];
            if ([weakSelf.title isEqualToString:@"专题详情"]) {
                weakSelf.gllpModel = [HouseListModel mj_objectWithKeyValues: [tempData[@"lplist"] firstObject]];
            }
            [weakSelf loadContent];
            weakSelf.headerView.titleLabel.text = strTitle;
            weakSelf.headerView.timeLabel.text = strTime;
            [weakSelf.webView loadHTMLString:[weakSelf adaptWebViewForHtml:[NSString stringWithFormat:@"%@",weakSelf.formatString]] baseURL:nil];
        }else{
        }
    }];
}


//list =     (  //新闻
//            {
//                id = 163,
//                publishdate = "2019-07-17",
//                title = "中建凤凰台 近地铁5号线精装房",
//                img = "http://192.168.99.234/storage/1PmV35bsjZvk5amAANdNys0bxYEhGYwHwKbDJBJf.png",
//            },


- (void)loadContent{
    CGFloat topImgHeight = 105;
    CGFloat bottomImgHeight = 200;
    if ([self.title isEqualToString:@"专题详情"]) {
        topImgHeight = 73;
    }
    if (self.gllpModel == nil) {
        bottomImgHeight = 0;
    }else{
        _boomshowView = [[NSBundle mainBundle] loadNibNamed:@"ZTDetialBottomView" owner:self options:nil].firstObject;
        [_webView.scrollView addSubview:_boomshowView];//添加自己的视图到_webView.scrollView
        _boomshowView.model = self.gllpModel;
        
        UIButton *taptap = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 100)];
        [taptap addTarget:self action:@selector(tapClickInto) forControlEvents:UIControlEventTouchUpInside];
        [_boomshowView addSubview:taptap];
    }
    _webView.scrollView.contentInset = UIEdgeInsetsMake(topImgHeight, 0, bottomImgHeight, 0);//上，左，下，右 改变webView上的H5页面的展示位置向下挪
    _headerView = [[NSBundle mainBundle] loadNibNamed:@"ZTDetialHeadView" owner:self options:nil].firstObject;
    _headerView.frame = CGRectMake(0, -(topImgHeight), SCREEN_WIDTH, topImgHeight);//注意添加视图时的坐标
    [_webView.scrollView addSubview:_headerView];//添加自己的视图到_webView.scrollView
}

- (void)tapClickInto{
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.strBH = _gllpModel.saleid;
    if (!vc.strBH) {
        vc.strBH = _gllpModel.xmbh;
    }
    [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.gllpModel != nil) {
            CGFloat heightWeb = [self.webView.scrollView contentSize].height;
            self.boomshowView.frame=CGRectMake(0, heightWeb, SCREEN_WIDTH, 200);
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    
//    CGFloat webViewHeight=[webView.scrollView contentSize].height;
////    CGRect newFrame=webView.frame;
////    newFrame.size.height=webViewHeight;
////    webView.frame=newFrame;
//    self.boomshowView.frame=CGRectMake(0, webViewHeight, SCREEN_WIDTH, 100);
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

- (void)dealloc{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
