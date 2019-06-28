//
//  AppendOneTipViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AppendOneTipViewController.h"
#import "AppendOneListViewController.h"
#import "ChooseAppendViewController.h"

@interface AppendOneTipViewController ()

@end

@implementation AppendOneTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"添加特殊人才";
}

- (IBAction)addNextClick:(id)sender {
    
    
    [self.navigationController pushViewController:[AppendOneListViewController new] animated:YES];
}

@end
