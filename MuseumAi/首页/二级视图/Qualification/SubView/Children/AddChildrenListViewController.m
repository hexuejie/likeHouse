//
//  AddChildrenListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AddChildrenListViewController.h"
#import "AddChildrenViewController.h"
#import "ChooseOtherRealViewController.h"
@interface AddChildrenListViewController ()

@end

@implementation AddChildrenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加子女信息";
}
- (IBAction)addChildrenClick:(id)sender {
    [LoginSession sharedInstance].pageType = 2;
    [self.navigationController pushViewController:[ChooseOtherRealViewController new] animated:YES];
//[self.navigationController pushViewController:[AddChildrenViewController new] animated:YES];
}

@end
