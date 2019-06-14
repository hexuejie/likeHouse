// MXPagerView.m
//
// Copyright (c) 2017 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <objc/runtime.h>
#import "MXPagerView.h"

@interface MXPagerViewDelegateForwarder : NSObject <UIScrollViewDelegate>
@property (nonatomic, weak) MXPagerView *pagerView;
@property (nonatomic, weak) id<MXPagerViewDelegate> delegate;
@end

@interface MXPagerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIViewController *> *pages;

@property (nonatomic, strong) NSMutableDictionary   *registration;
@property (nonatomic, strong) NSMutableArray        *reuseQueue;
@end

@implementation MXPagerView {
    CGFloat     _index;
    NSInteger   _count;
    
    MXPagerViewDelegateForwarder *_forwarder;
}

@dynamic delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _forwarder = [[MXPagerViewDelegateForwarder alloc] init];
    _forwarder.pagerView = self;
    
    super.delegate = _forwarder;
    self.pagingEnabled = YES;
    self.scrollsToTop = NO;
    self.directionalLockEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.pages = [NSMutableDictionary dictionary];
    self.registration = [NSMutableDictionary dictionary];
    self.reuseQueue = [NSMutableArray array];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_count <= 0) {
        [self reloadData];
    }
    
    CGSize size = self.bounds.size;
    size.width = size.width * _count;
    
    if (!CGSizeEqualToSize(size, self.contentSize)) {
        self.contentSize = size;
        
        CGFloat x = self.bounds.size.width * _index;
        [super setContentOffset:CGPointMake(x, 0) animated:NO];
        
        //Layout loaded pages
        CGRect frame = CGRectZero;
        frame.size = self.bounds.size;
        for (NSNumber *key in self.pages) {
            UIViewController *page = self.pages[key];
            frame.origin.x = frame.size.width * [key integerValue];
            page.view.frame = frame;
        }
    }
}

- (void)reloadData {
    
    // Removes all current pages.
    NSUInteger index = 0;
    for (NSNumber *key in self.pages) {
        UIViewController *page = self.pages[key];
        NSUInteger index = [key integerValue];
        if ([self.delegate respondsToSelector:@selector(pagerView:willDisplayPage:atIndex:)]) {
            [self.delegate pagerView:self willDisplayPage:page atIndex:index];
        }
        [page.view removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(pagerView:didDisplayPage:atIndex:)]) {
            [self.delegate pagerView:self didDisplayPage:page atIndex:index];
        }
    }
    [self.pages removeAllObjects];
    
    //Updates index and loads the current selected page
    if ( (_count = [self.dataSource numberOfPagesInPagerView:self]) > 0) {
        _index = MIN(_index, _count - 1);
        [self loadPageAtIndex:_index];
        [self setNeedsLayout];
    }
}

- (void)showPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index >= 0 && index < _count && index != _index) {
        //The tab behavior disable animation
        animated = (self.transitionStyle == MXPagerViewTransitionStyleTab)? NO : animated;
        
        CGFloat x = self.bounds.size.width * index;
        [self setContentOffset:CGPointMake(x, 0) animated:animated];
    }
}

- (UIViewController *)pageAtIndex:(NSInteger)index {
    NSNumber *key = [NSNumber numberWithInteger:index];
    return self.pages[key];
}

#pragma mark Reusable Pages

- (void)registerNib:(UINib *)nib forPageReuseIdentifier:(NSString *)identifier {
    [self.registration setValue:nib forKey:identifier];
}

- (void)registerClass:(Class)pageClass forPageReuseIdentifier:(NSString *)identifier {
    [self.registration setValue:NSStringFromClass(pageClass) forKey:identifier];
}

- (UIViewController *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    
    UIViewController *page = nil;
    
    for (UIViewController *reuse in self.reuseQueue) {
        if ([reuse.reuseIdentifier isEqualToString:identifier]) {
            page = reuse;
            break;
        }
    }
    
    if (!page) {
        id builder = self.registration[identifier];
        NSAssert(builder, @"unable to dequeue a page with identifier %@ - must register a nib or a class for the identifier", identifier);
        
        if ([builder isKindOfClass:[UINib class]]) {
            page = [[(UINib *)builder instantiateWithOwner:nil options:nil] firstObject];
        } else if ([builder isKindOfClass:[NSString class]]) {
            page = [[NSClassFromString(builder) alloc] init];
        } else {
            page = [UIViewController new];
        }
        
        objc_setAssociatedObject(page, @selector(reuseIdentifier), identifier, OBJC_ASSOCIATION_COPY);
    } else {
        [self.reuseQueue removeObject:page];
        [page prepareForReuse];
    }
    
    return page;
}

#pragma mark Properties

- (id<MXPagerViewDelegate>)delegate {
    return _forwarder.delegate;
}

- (void)setDelegate:(id<MXPagerViewDelegate>)delegate {
    super.delegate = nil;
    _forwarder.delegate = delegate;
    super.delegate = _forwarder;
}

- (UIViewController *)selectedPage {
    NSNumber *key = [NSNumber numberWithInteger:_index];
    return self.pages[key];
}

- (NSInteger)indexForSelectedPage {
    return _index;
}

- (void)setTransitionStyle:(MXPagerViewTransitionStyle)transitionStyle {
    _transitionStyle = transitionStyle;
    //the tab behavior disable the scroll
    self.scrollEnabled = (transitionStyle != MXPagerViewTransitionStyleTab);
}

- (void)setGutterWidth:(CGFloat)gutterWidth {
    _gutterWidth = gutterWidth;
    [self setNeedsLayout];
}

- (NSArray<UIViewController *> *)loadedPages {
    return [self.pages allValues];
}

- (CGFloat)progress {
    CGFloat position  = self.contentOffset.x;
    CGFloat width     = self.bounds.size.width;
    
    return position / width;
}

#pragma mark Private Methods

- (void)willMovePageToIndex:(NSInteger)index {
    [self loadPageAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(pagerView:willMoveToPage:atIndex:)]) {
        UIViewController *page = self.pages[@(index)];
        [self.delegate pagerView:self willMoveToPage:page atIndex:index];
    }
}

- (void)didMovePageToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pagerView:didMoveToPage:atIndex:)]) {
        UIViewController *page = self.pages[@(index)];
        [self.delegate pagerView:self didMoveToPage:page atIndex:index];
    }
    
    //The page did change, now unload hidden pages
    [self unLoadHiddenPages];
}

- (void)loadPageAtIndex:(NSInteger)index {

    void(^loadPage)(NSInteger index) = ^(NSInteger index) {

        if (!self.pages[@(index)] && (index >= 0) && (index < _count)) {

            //Load page
            UIViewController *page = [self.dataSource pagerView:self viewForPageAtIndex:index];

            self.pages[@(index)] = page;
            if ([self.delegate respondsToSelector:@selector(pagerView:willDisplayPage:atIndex:)]) {
                [self.delegate pagerView:self willDisplayPage:page atIndex:index];
            }

            //Layout page
            CGRect frame = CGRectZero;
            frame.size = self.bounds.size;
            frame.origin = CGPointMake(frame.size.width * index, 0);
            page.view.frame = frame;
            page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

            [self addSubview:page.view];

            NSMutableArray *toUnLoad = [NSMutableArray array];
            for (NSNumber *key in self.pages) {
                NSInteger unindex = [key integerValue];

                if (unindex != index) {

                    UIViewController *unpage = self.pages[key];
                    if ([self.delegate respondsToSelector:@selector(pagerView:willEndDisplayPage:atIndex:)]) {
                        [self.delegate pagerView:self willEndDisplayPage:unpage atIndex:unindex];
                    }

                    [unpage.view removeFromSuperview];
                    [toUnLoad addObject:key];
                }
            }

            for (NSNumber *key in self.pages) {
                NSInteger unindex = [key integerValue];

                if (unindex != index) {

                    UIViewController *unpage = self.pages[key];
                    if ([self.delegate respondsToSelector:@selector(pagerView:willEndDisplayPage:atIndex:)]) {
                        [self.delegate pagerView:self didEndDisplayPage:unpage atIndex:unindex];
                    }
                }

            }
            [self.pages removeObjectsForKeys:toUnLoad];

            if ([self.delegate respondsToSelector:@selector(pagerView:didDisplayPage:atIndex:)]) {
                [self.delegate pagerView:self didDisplayPage:page atIndex:index];
            }
            //Save page

        }
    };

    loadPage(index);
}

- (void)unLoadHiddenPages {
    
    NSMutableArray *toUnLoad = [NSMutableArray array];
    

//    [self.pages removeObjectsForKeys:toUnLoad];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    
    if (!fmod(contentOffset.x, self.bounds.size.width)) {
        NSInteger index = contentOffset.x /self.bounds.size.width;
        
        [self willMovePageToIndex:index];
        [super setContentOffset:contentOffset animated:animated];
        
        _index = index;
        
        if(!animated) {
            [self didMovePageToIndex:index];
        }
        
    } else {
        [super setContentOffset:contentOffset animated:animated];
    }
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger position  = scrollView.contentOffset.x;
    NSInteger width     = scrollView.bounds.size.width;
    
    _index = position / width;
    [self didMovePageToIndex:_index];

    if ([self.delegate respondsToSelector:@selector(pagerViewEndScroll:)]){
        [self.delegate pagerViewEndScroll:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger position  = targetContentOffset->x;
    NSInteger width     = scrollView.bounds.size.width;
    
    NSInteger index = position / width;
    [self willMovePageToIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self didMovePageToIndex:_index];

    

    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

#pragma mark <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self];
        
        //Lock vertical pan gesture.
        if (fabs(velocity.x) < fabs(velocity.y)) {
            return NO;
        }

        if (!self.unlock){
            if ([self.delegate respondsToSelector:@selector(pagerViewDidScroll:)]){
                [self.delegate pagerViewDidScroll:self];
            }
        }

    }
    return YES;
}


@end

@implementation UIViewController (ReuseIdentifier)

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self init]) {
        objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [self initWithCoder:aDecoder]) {
        objc_setAssociatedObject(self, @selector(reuseIdentifier), reuseIdentifier, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (NSString *)reuseIdentifier {
    return objc_getAssociatedObject(self, @selector(reuseIdentifier));
}

- (void)prepareForReuse {
    
}

@end

@implementation MXPagerViewDelegateForwarder

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.pagerView respondsToSelector:aSelector]) {
        return self.pagerView;
    }
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.pagerView respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}
@end
