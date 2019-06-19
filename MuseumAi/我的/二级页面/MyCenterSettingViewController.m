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
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation MyCenterSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    self.title = @"用户设置";
    
//    self.cacheLabel.text = [NSString stringWithFormat:@"%fMB",[self sizeGetWebImageCache]];
    [self sizeGetWebImageCache];
}

- (IBAction)chacheOutClick:(id)sender {
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定清理缓存?"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[SDImageCache sharedImageCache] clearMemory];
//            self.cacheLabel.text = [NSString stringWithFormat:@"%fMB",[self sizeGetWebImageCache]];
            [self sizeGetWebImageCache];
            self.cacheLabel.text = @"0kb";
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

- (float)sizeGetWebImageCache{
  
    unsigned long iLength = [[SDImageCache sharedImageCache] getSize]/1024.0;
    
    if(iLength > 1024.0)
        
    {
        
        iLength = iLength/1024.0;
        
        NSString *sLength = [NSString stringWithFormat:@"%lu",iLength];
        
        self.cacheLabel.text = [sLength stringByAppendingString:@"M"];
        
    }
    
    else
        
    {
        
        NSString *sLength = [NSString stringWithFormat:@"%lu",iLength-73];
        
        self.cacheLabel.text = [sLength stringByAppendingString:@"kb"];
        
    }
    

    　NSInteger sizeInteger = [[NSURLCache sharedURLCache] currentDiskUsage];
    
    　float sizeInMB = sizeInteger / (1024.0f * 1024.0f);
    return sizeInMB;
}

@end
