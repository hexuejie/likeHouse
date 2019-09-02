//
//  InformationLookoutViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/8/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "InformationLookoutViewController.h"
#import "CloudWebController.h"
#import "UIView+add.h"

@interface InformationLookoutViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;

@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;


@end

@implementation InformationLookoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"信息查询";
    
    [self.bgView1 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView2 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView3 setCornerRadius:5 withShadow:YES withOpacity:10];
    [self.bgView4 setCornerRadius:5 withShadow:YES withOpacity:10];
}


- (IBAction)mainClick:(UIButton *)sender {
    
    CloudWebController *controller = [[CloudWebController alloc] init];
    switch (sender.tag) {
        case 0:
            {
                 controller.requestURL = @"http://www.cszjw.net/preselllicence_mobile";
                controller.title = @"预售证查询";
            }
            break;
        case 1:
        {
            controller.requestURL = @"http://www.cszjw.net/signedcontract_mobile";
            controller.title = @"合同签订查询";
        }
            break;
        case 2:
        {
            controller.requestURL = @"http://www.cszjw.net/registration_mobile";
            controller.title = @"合同备案查询";
        }
            break;
        case 3:
        {
            controller.requestURL =[NSString stringWithFormat:@"http://www.gov.cn/pushinfo/v150203/pushinfo.jsonp?pushInfoJsonpCallBack=pushInfoJsonpCallBack&_=%@",[LoginSession sharedInstance].phone] ;
            controller.title = @"公积金查询";
        }
            break;
            
        default:
            break;
    }
//    controller.webView.title = controller.title;
    [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
}



@end
