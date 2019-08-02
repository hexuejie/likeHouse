//
//  ESSegmentBaseViewController.m
//  lexiwed2
//
//  Created by Kyle on 2017/3/17.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "ESSegmentBaseViewController.h"
#import "Utility.h"

@interface ESSegmentBaseViewController ()

@property (nonnull,nonatomic,strong) MXSegmentedPager *segmentedPager;

@end

@implementation ESSegmentBaseViewController

- (void)loadView {
    self.view = self.segmentedPager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _headViewMaxHeight = 200.0f;
    _headViewMinHeight = [Utility segmentTopMinHeight];

    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    // Parallax Header

    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : kUIColorFromRGB(0x999999),NSFontAttributeName:kSysFont(16.0)};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : MJThemeColor,NSFontAttributeName:kSysFont(16.0)};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 3;
    self.segmentedPager.segmentedControl.selectionIndicatorCornerRadius = 1.5;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = MJThemeColor;
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake([Utility segmentTopMinHeight], 0, 0, 0);

    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.translatesAutoresizingMaskIntoConstraints = false;
    [self.segmentedPager.segmentedControl addSubview:line];
    line.layer.zPosition += 3;
    line.backgroundColor = kUIColorFromRGB(0xe5e5e5);

    [self.segmentedPager.segmentedControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[line(1000)]" options:NSLayoutFormatAlignAllLeft metrics:@{} views:@{@"line":line}]];
    [self.segmentedPager.segmentedControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]|" options:NSLayoutFormatAlignAllTop metrics:@{} views:@{@"line":line}]];
    [self.segmentedPager.segmentedControl addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.segmentedPager.segmentedControl attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

#pragma mark
#pragma property

- (MXSegmentedPager *)segmentedPager {
    if (!_segmentedPager) {

        // Set a segmented pager below the cover
        _segmentedPager = [[MXSegmentedPager alloc] init];
        _segmentedPager.delegate    = self;
        _segmentedPager.dataSource  = self;
    }
    return _segmentedPager;
}

-(void)setSubViewControllers:(NSArray *)subViewControllers{
    if (subViewControllers.count == 0) {
        NSLog(@"setSegmentControllers count == 0");
        return;
    }

    _subViewControllers = subViewControllers;
    [self.segmentedPager reloadData];
}

-(void)setHeadView:(UIView *)headView{
    if (_headView == headView){
        return;
    }
    _headView = headView;
    self.segmentedPager.parallaxHeader.view = _headView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeBottom;
    self.segmentedPager.parallaxHeader.height = _headViewMaxHeight;
    self.segmentedPager.parallaxHeader.minimumHeight = _headViewMinHeight;
}

-(void)setHeadViewMaxHeight:(CGFloat)headViewMaxHeight{
    if (self.headView == nil){
        return;
    }
    _headViewMaxHeight = headViewMaxHeight;

    self.segmentedPager.parallaxHeader.height = _headViewMaxHeight;
}

-(void)setHeadViewMinHeight:(CGFloat)headViewMinHeight{
    if (self.headView == nil){
        return;
    }
    _headViewMinHeight = headViewMinHeight;

    self.segmentedPager.parallaxHeader.minimumHeight = _headViewMinHeight;
}

#pragma mark MXSegmengPageDelegate
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"selectedSegmentIndex  %ld  %@",segmentedPager.segmentedControl.selectedSegmentIndex,title);
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didScrollWithParallaxHeader:(MXParallaxHeader *)parallaxHeader {
    //    NSLog(@"progress %f", parallaxHeader.progress);
}

-(void)segmentedPager:(MXSegmentedPager *)segmentedPager didScroll:(UIScrollView*)scrollView{
}


-(void)segmentedPager:(MXSegmentedPager *)segmentedPager willDisplayPage:(UIViewController *)page atIndex:(NSInteger)index{
    [page willMoveToParentViewController:self];
    [self addChildViewController:page];
}

-(void)segmentedPager:(MXSegmentedPager *)segmentedPager didDisplayPage:(UIViewController *)page atIndex:(NSInteger)index{
    [page didMoveToParentViewController:self];
}

-(void)segmentedPager:(MXSegmentedPager *)segmentedPager willEndDisplayPage:(UIViewController *)page atIndex:(NSInteger)index{
    [page willMoveToParentViewController:nil];
    [page removeFromParentViewController];
}

-(void)segmentedPager:(MXSegmentedPager *)segmentedPager didEndDisplayPage:(UIViewController *)page atIndex:(NSInteger)index{
    [page didMoveToParentViewController:nil];
}




-(CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 46;
}

#pragma mark <MXSegmentedPagerDataSource>
- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager {
    return self.subViewControllers.count;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    if (self.subViewControllers.count <= index ){
        return @"";
    }
    UIViewController *viewController = self.subViewControllers[index];
    return viewController.title == nil ? @" ":viewController.title;
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index {
    if (self.subViewControllers.count <= index ){
        return [UIViewController new];
    }
    UIViewController *viewController = self.subViewControllers[index];
    return viewController;
}

#pragma mark <MXPageSegueSource>



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
