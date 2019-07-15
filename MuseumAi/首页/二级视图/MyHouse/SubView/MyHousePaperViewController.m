//
//  MyHousePaperViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/11.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHousePaperViewController.h"

@interface MyHousePaperViewController ()

@end

@implementation MyHousePaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:myWebView];
    myWebView.backgroundColor = [UIColor whiteColor];
    NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_url]];
    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
    [myWebView loadRequest:request];
    //使文档的显示范围适合UIWebView的bounds
    [myWebView setScalesPageToFit:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
