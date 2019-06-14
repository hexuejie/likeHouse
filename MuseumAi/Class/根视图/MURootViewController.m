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
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(callBackClick)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kDidLoginSuccessNotification object:nil];
    
//    [self reloadData];
}

- (void)reloadData{}


- (void)callBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)testButtonClick{
//    [self.navigationController pushViewController:[MURootViewController new] animated:YES];
    
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
