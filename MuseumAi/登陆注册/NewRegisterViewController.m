//
//  NewRegisterViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/19.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "NewRegisterViewController.h"

@interface NewRegisterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;

@end

@implementation NewRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navHeight.constant = [Utility segmentTopMinHeight];
    
}


- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
