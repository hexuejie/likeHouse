//
//  MyHouseCodeViewController.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/18.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "MyHouseCodeViewController.h"
#import "QiCodeManager.h"
#import "UIView+add.h"

@interface MyHouseCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageViewTop;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageMid;
@property (weak, nonatomic) IBOutlet UIView *codeBackGround;

@end

@implementation MyHouseCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.codeBackGround setCornerRadius:5 withShadow:YES withOpacity:5];
    [self.codeBackGround setCornerRadius:4 withShadow:YES withOpacity:10 withAlpha:0.1 withCGSize:CGSizeMake(1, 4)];
    self.view.backgroundColor = kUIColorFromRGB(0xF1F1F1);
    
    __block NSString *text = _codeLabel.text;
    __block CGSize size = _codeImageMid.bounds.size;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *code = text;
        UIImage *codeImage = [QiCodeManager generateQRCode:code size:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImageMid.image = codeImage;
        });
    });
    
    __block CGSize size2 = _codeImageViewTop.bounds.size;//条码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *code = text;
        UIImage *codeImage = [QiCodeManager generateCode128:code size:size2];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.codeImageViewTop.image = codeImage;
        });
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (IBAction)navBackClick:(id)sender {
    [self callBackClick];
}


@end
