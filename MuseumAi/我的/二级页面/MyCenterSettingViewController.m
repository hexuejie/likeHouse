//
//  MyCenterSettingViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/10.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyCenterSettingViewController.h"
#import "SDImageCache.h"
#import "RealFinishTipView1.h"

@interface MyCenterSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (strong, nonatomic) RealFinishTipView1 *tipView1;
@end

@implementation MyCenterSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = kListBgColor;
    self.title = @"用户设置";
    

    // 计算缓存大小
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    float size = [self folderSizeAtPath:cachesDir];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",size];
    
}

- (IBAction)chacheOutClick:(id)sender {
    
    _tipView1 = [[NSBundle mainBundle] loadNibNamed:@"RealFinishTipView1" owner:self options:nil].firstObject;
    _tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:_tipView1];
    _tipView1.sureType = -1;
    
    [_tipView1.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_tipView1.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _tipView1.contentTitleLabel.text = @"确定清理缓存?";
    [_tipView1.sureButton addTarget:self action:@selector(loginoutFinishClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)loginoutFinishClick{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    [self clearCache:cachesDir];
    [SVProgressHelper dismissWithMsg:@"清理成功"];
  
    float size = [self folderSizeAtPath:cachesDir];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",size];
}

- (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        // SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

- (void)clearCache:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}

- (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}





- (IBAction)updateClick:(id)sender {
//    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",@"56ce54a5"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%82%A6%E5%B1%85%E6%98%9F%E5%9F%8E/id1417052839?mt=8"]];
}
@end
