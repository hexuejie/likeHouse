//
//  AddChildrenListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AddChildrenListViewController.h"
#import "AddChildrenViewController.h"
@interface AddChildrenListViewController ()

@end

@implementation AddChildrenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加子女信息";
}
- (IBAction)addChildrenClick:(id)sender {
[self.navigationController pushViewController:[AddChildrenViewController new] animated:YES];
}

@end
