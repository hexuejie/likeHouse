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
    
    self.title = @"关于长沙购房APP";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.TitleAndVersion.text = [NSString stringWithFormat:@"长沙购房：V%@",app_Version];
}


@end
