//
//  MyHousePaySuccessViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/26.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHousePaySuccessViewController.h"
#import "MyHouseDetialViewController.h"

@interface MyHousePaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel4;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel5;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel6;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel7;




@end

@implementation MyHousePaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"支付成功";
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.contentLabel1.text = [NSString stringWithFormat:@"%@",self.dataDic[@"jyid"]];
        self.contentLabel2.text = [NSString stringWithFormat:@"%@",self.dataDic[@"zfje"]];//dataDic[@"zfje"];
        self.contentLabel3.text = [NSString stringWithFormat:@"%@",self.dataDic[@"zffs"]];//dataDic[@""];
        self.contentLabel4.text = [NSString stringWithFormat:@"%@",self.dataDic[@"jyrq"]];//dataDic[@""];
        
        
        self.contentLabel5.text = [NSString stringWithFormat:@"%@",self.dataDic[@"ckr"]];//dataDic[@""];
        self.contentLabel6.text = [NSString stringWithFormat:@"%@",self.dataDic[@"skmc"]];//dataDic[@""];
        self.contentLabel7.text = [NSString stringWithFormat:@"%@",self.dataDic[@"fkhmc"]];//dataDic[@""];
    });
}

- (IBAction)backClick:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyHouseDetialViewController class]]) {
            MyHouseDetialViewController *A =(MyHouseDetialViewController *)controller;
            [self.navigationController popToViewController:A animated:YES];
        }
    }
}


@end
