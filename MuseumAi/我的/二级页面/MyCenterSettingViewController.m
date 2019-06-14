//
//  MyCenterSettingViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterSettingViewController.h"
#import "SDImageCache.h"

@interface MyCenterSettingViewController ()

@end

@implementation MyCenterSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    self.title = @"用户设置";
}

- (IBAction)chacheOutClick:(id)sender {
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定清理缓存?"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[SDImageCache sharedImageCache] clearMemory];
        });
        
    }];
    [alert addAction:cancle];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)updateClick:(id)sender {
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",@"56ce54a5"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%82%A6%E5%B1%85%E6%98%9F%E5%9F%8E/id1417052839?mt=8"]];
}

@end
