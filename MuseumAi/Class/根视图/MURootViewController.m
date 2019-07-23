//
//  MURootViewController.m
//  MuseumAi
//
//  Created by Kingo on 2018/9/18.
//  Copyright © 2018年 Weizh. All rights reserved.
//

#import "MURootViewController.h"
#import "HouseDetialViewController.h"

@interface MURootViewController ()

@end

@implementation MURootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UINavigationBar appearance].tintColor = kUIColorFromRGB(0x333333);
    [UINavigationBar appearance].barTintColor = kUIColorFromRGB(0xffffff);
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"nav_back"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"nav_back"];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:kUIColorFromRGB(0x444444)}];
    _backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_backItem setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [_backItem addTarget:self action:@selector(callBackClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:_backItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kDidLoginSuccessNotification object:nil];
    
    [self reloadData];
    
    
    [[UINavigationBar appearance] setShadowImage: [self viewImageFromColor:kUIColorFromRGB(0xf7f7f7) rect:CGRectMake(0, 0, SCREEN_WIDTH, 1)]];
}

- (UIImage *)viewImageFromColor:(UIColor *)color rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)reloadData{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)callBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    
    if ([LoginSession sharedInstance].isNavigationBarHidden == NO) {
         [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
//    if ([self isEqual:self.navigationController.viewControllers[0]]) {
//        // 切tab的时候需要还原tabbar状态为显示
//        if (self.navigationController.viewControllers.count == 1) {
//            // 不是present新页面
//            if (!self.presentedViewController) {
//                [self.tabBarController.tabBar setHidden:NO];
//            }
//        } else {
//            // 上一次被hidden过了, 这次需要手动隐藏tabbar，否则tabbar不会隐藏，设置了hidesBottomWhenPush也没用
//            if (1) {
//                self.tabBarController.tabBar.hidden = YES;
//                //                _hideTabbarBefore = NO;
//            }
//            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
//                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//            }
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [LoginSession sharedInstance].isNavigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}




- (void)addNoneDataTipView{
    UIView *tipView1 = [[NSBundle mainBundle] loadNibNamed:@"NoneDataTipView" owner:self options:nil].firstObject;
    tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    tipView1.tag = 9595;
    if (!_allView) {
        _allView = self.view;
    }
    [_allView addSubview:tipView1];
    
    [tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(_allView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(_allView.bounds.size.height);
    }];
}

- (void)removeNoneDataTipView{
    if (!_allView) {
        _allView = self.view;
    }
    
    UIView *tipView1 = [_allView viewWithTag:9595];
    if (tipView1) {
        [tipView1 removeFromSuperview];
    }
}


- (void)addErrprTipView{
    UIView *tipView1 = [[NSBundle mainBundle] loadNibNamed:@"NoneDataTipView" owner:self options:nil].lastObject;
    tipView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    tipView1.tag = 9696;
    
    if (!_allView) {
        _allView = self.view;
    }
    [_allView addSubview:tipView1];
    
    tipView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadData)];
    [tipView1 addGestureRecognizer:tap];
    
    [tipView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(_allView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(_allView.bounds.size.height);
    }];
}

- (void)removeErrorTipView{
    if (!_allView) {
        _allView = self.view;
    }
    UIView *tipView1 = [_allView viewWithTag:9696];
    if (tipView1) {
        [tipView1 removeFromSuperview];
    }
}


- (void)loadingPageSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self removeNoneDataTipView];
    [self removeErrorTipView];
}

- (void)loadingPageError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertWithMsg:kFailedTips handler:nil];
    [self addErrprTipView];
}

- (void)loadingPageWidthSuccess:(BOOL)success{
    if (success) {
        [self loadingPageSuccess];
    }else{
        [self loadingPageError];
    }
}
@end
