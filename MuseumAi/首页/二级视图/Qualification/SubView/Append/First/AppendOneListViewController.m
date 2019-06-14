//
//  AppendOneListViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/6.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "AppendOneListViewController.h"
#import "ChooseAppendViewController.h"

@interface AppendOneListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation AppendOneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加特殊人才";
    
    self.addButton.userInteractionEnabled = YES;
    [self.addButton addTarget:self action:@selector(addPersonClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (IBAction)addPersonClick:(id)sender {
    [self.navigationController pushViewController:[ChooseAppendViewController new] animated:YES];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self.addButton;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}
@end
