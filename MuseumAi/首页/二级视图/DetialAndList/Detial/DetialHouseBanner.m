//
//  DetialHouseBanner.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/6/28.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialHouseBanner.h"

#import "CloudWebController.h"
#import "DetialPictureSegmentViewController.h"
#import "HouseDetialViewController.h"

@interface DetialHouseBanner ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *leftImageV, *middleImageV, *rightImageV;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation DetialHouseBanner

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat heightH = self.bounds.size.height;
        self.contentSize = CGSizeMake(SCREEN_WIDTH*3, self.bounds.size.height);
        self.leftImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 0, heightH)];
        [self addSubview:self.leftImageV];
        
        self.middleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH+0, 0, SCREEN_WIDTH - 0, heightH)];
        [self addSubview:self.middleImageV];
        
        self.rightImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2+ 0, 0, SCREEN_WIDTH - 0, heightH)];
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
        self.rightImageV.clipsToBounds = YES;
        self.middleImageV.clipsToBounds = YES;
        self.leftImageV.clipsToBounds = YES;
        
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
    
    [self.leftImageV setOtherImageUrl:self.imageArray[leftimageindex].img];
    [self.middleImageV setOtherImageUrl:self.imageArray[_currentIndex].img];
    [self.rightImageV setOtherImageUrl:self.imageArray[rightimageindex].img];
    
    
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
        DetialPictureSegmentViewController *vc = [DetialPictureSegmentViewController new];
        vc.currentIndex = index;
        vc.pictureArray = self.imageArray;
        [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
        return;
    }
    
    zstListHousePicture *admodel = self.imageArray[index];
    if (!admodel.bh) {
        return;
    }
    HouseDetialViewController *vc = [HouseDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.strBH = admodel.lpbh;
    [[ProUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    
}
@end

