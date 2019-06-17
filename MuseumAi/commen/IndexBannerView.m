//
//  IndexBannerView.m
//  banni
//
//  Created by zhudongliang on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IndexBannerView.h"
//#import "ProUtils.h"
#import "CloudWebController.h"
#import "DetialPictureSegmentViewController.h"
#import "HouseDetialViewController.h"

@interface IndexBannerView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *leftImageV, *middleImageV, *rightImageV;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation IndexBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat heightH = self.bounds.size.height;
        self.contentSize = CGSizeMake(SCREEN_WIDTH*3, self.bounds.size.height);
        self.leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 0, heightH)];
//        self.leftImageV.layer.cornerRadius = 5;
//        self.leftImageV.layer.masksToBounds = YES;
        [self addSubview:self.leftImageV];
        
        self.middleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH+0, 0, SCREEN_WIDTH - 0, heightH)];
//        self.middleImageV.layer.cornerRadius = 5;
//        self.middleImageV.layer.masksToBounds = YES;
        [self addSubview:self.middleImageV];
        
        self.rightImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2+ 0, 0, SCREEN_WIDTH - 0, heightH)];
//        self.rightImageV.layer.cornerRadius = 5;
//        self.rightImageV.layer.masksToBounds = YES;
        [self addSubview:self.rightImageV];
        
        self.rightImageV.userInteractionEnabled = self.leftImageV.userInteractionEnabled = self.middleImageV.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.rightImageV.backgroundColor = self.middleImageV.backgroundColor = self.leftImageV.backgroundColor = [UIColor clearColor];
        
        [self.rightImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        [self.middleImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        [self.leftImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        self.rightImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.middleImageV.contentMode = UIViewContentModeScaleAspectFill;
        self.leftImageV.contentMode = UIViewContentModeScaleAspectFill;
        
//        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 70, 100, 70)];
//        [self.pageControl setPageIndicatorTintColor:UIColorFromRGB(0xffffff)];
//        [self.pageControl setCurrentPageIndicatorTintColor:UIColorFromRGB(0xf94f4f)];
//        [self.pageControl setBackgroundColor:[UIColor blueColor]];
//        [self addSubview:self.pageControl];
        self.pagingEnabled = YES;
        self.clipsToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentOffset = CGPointMake(self.bounds.size.width, 0);
        self.bounces = NO;
        self.delegate = self;
        [self loadTimer];
    }
    return self;
}


- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
//    self.pageControl.currentPage = currentIndex;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
//    self.pageControl.numberOfPages = _imageArray.count;
    self.currentIndex = 0;
    if (_imageArray.count == 0) {
        self.scrollEnabled = NO;
        return;
    }
    self.scrollEnabled =  YES;
    [self resetImage];
}
- (void)nextImage {
    switch (_imageArray.count) {
        case 0:
            break;
        case 1:
            break;
        default:
            [self setContentOffset:CGPointMake(self.bounds.size.width*2, 0) animated:YES];
            //            [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
            break;
    }
    
}
- (void)resetImage{
    if (_imageArray.count == 0) {
        return;
    }
    NSInteger leftimageindex=(_currentIndex+self.imageArray.count-1)%self.imageArray.count;
    NSInteger rightimageindex=(_currentIndex +1)%self.imageArray.count;
   
    [self.leftImageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[leftimageindex].img] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
    }];
    [self.middleImageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[_currentIndex].img] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
    }];
    
    [self.rightImageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[rightimageindex].img] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
   
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = [scrollView contentOffset];
    if (_imageArray.count == 0) {
        return;
    }
    if (contentOffset.x > self.bounds.size.width) { //向左滑动
        self.currentIndex = (self.currentIndex +1 )% self.imageArray.count;
    } else if (contentOffset.x < self.bounds.size.width) { //向右滑动
        self.currentIndex=(self.currentIndex +(self.imageArray.count-1))%self.imageArray.count;
    }
    [self resetImage];
    [self setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO] ;
    
    NSLog(@"currentIndex  %ld",_currentIndex);
    if ([self.customdelegate respondsToSelector:@selector(scrollerIndexBannerView:forIndex:)]) {
        return [self.customdelegate scrollerIndexBannerView:self forIndex:_currentIndex];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //使定时器失效
    [self.timer invalidate];
    self.timer = nil;
}

//设置代理方法,当拖拽结束的时候,调用计时器,让其继续自动滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //重新启动定时器
    [self loadTimer];
}
//加载定时器
- (void)loadTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    //取得主循环
    NSRunLoop *mainLoop=[NSRunLoop currentRunLoop];
    //将其添加到运行循环中(监听滚动模式)
    [mainLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)clickImage:(UITapGestureRecognizer*)tap{
    if (_imageArray.count == 0) {
        return;
    }
    UIImageView *imageV = (UIImageView*)tap.view;
    NSInteger index = 0;
    if (imageV == _leftImageV) {
        index =(_currentIndex+self.imageArray.count-1)%self.imageArray.count;
    }
    if (imageV == _middleImageV) {
        index = _currentIndex;
    }
    if (imageV == _rightImageV) {
        index =(_currentIndex +1)%self.imageArray.count;
    }
    if (self.tag == 998) {
         [[ProUtils getCurrentVC].navigationController pushViewController:[DetialPictureSegmentViewController new] animated:YES];
        return;
    }
    
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    
    
//    AdModel *admodel = self.imageArray[index];
////    [ProUtils clickModelWithJumpType:admodel.jumpType relateId:admodel.relateId h5Url:admodel.linkUrl];
//    CloudWebController *controller = [[CloudWebController alloc] init];
//    controller.requestURL = admodel.linkUrl;
//    [[ProUtils getCurrentVC].navigationController pushViewController:controller animated:YES];
    
    
//
//    
//    AdModel *info ;
//    info = self.imageArray[_currentIndex];
//    [ProUtils clickModelWithJumpType:info.jumpType relateId:info.relateId h5Url:info.linkUrl];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
