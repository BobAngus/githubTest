//
//  GDIInfiniteScrollView.m
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIInfinitePageScrollViewController.h"

@interface GDIInfinitePageScrollViewController()
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger prevIndex;

@property (strong, nonatomic) NSDate *moveToIndexStartTime;
@property (strong, nonatomic) NSTimer *moveToIndexTimer;
@property (nonatomic) CGFloat moveToIndexOffsetStartValue;
@property (nonatomic) CGFloat moveToIndexOffsetDelta;
@property (nonatomic) CGFloat moveToIndexOffsetDuration;

- (void)initializeView;

- (void)updateContentSize;
- (void)updateCurrentViewController;
- (void)updateCurrentIndex;

- (void)initFirstViewController;
- (void)initLastViewController;
- (void)initCurrentViewController;
- (void)loadPrevViewController;
- (void)loadNextViewController;

- (void)resetScrollToBeginning;
- (void)resetScrollToEnd;
- (void)unloadUnusedViewControllers;

- (void)layoutViews;

- (NSUInteger)indexOfPreviousController;
- (NSUInteger)indexOfNextController;

- (void)scrollToCurrentIndex;
- (void)notifyDelegateOfCurrentIndexChange;
- (void)notifyDelegateOfOffsetChange;

- (void)moveToIndex:(NSInteger)index;
- (void)handleMoveToIndexTick;
- (CGFloat)easeInOutWithCurrentTime:(CGFloat)t start:(CGFloat)b change:(CGFloat)c duration:(CGFloat)d;

@end

@implementation GDIInfinitePageScrollViewController

@synthesize pageViewControllers;
@synthesize currentIndex;
@synthesize scrollView = _scrollView;
@synthesize delegate;
@synthesize isScrolling;

@synthesize prevIndex = _prevIndex;
@synthesize viewControllers = _viewControllers;
@synthesize moveToIndexStartTime = _moveToIndexStartTime;
@synthesize moveToIndexTimer = _moveToIndexTimer;
@synthesize moveToIndexOffsetStartValue = _moveToIndexOffsetStartValue;
@synthesize moveToIndexOffsetDelta = _moveToIndexOffsetDelta;
@synthesize moveToIndexOffsetDuration = _moveToIndexOffsetDuration;

#pragma mark - View Controller Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewControllers = [NSMutableArray array];
    }
    return self;
}


- (id)initWithViewControllers:(NSArray *)viewControllers
{
    self = [self init];
    if (self) {
        _viewControllers = [NSMutableArray arrayWithArray:viewControllers];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewControllers = [NSMutableArray array];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self unloadUnusedViewControllers];
}


- (void)loadView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.view = self.scrollView;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.f;
    self.scrollView.maximumZoomScale = 1.f;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self updateContentSize];
        [self layoutViews];
        [self scrollToCurrentIndex];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initializeView];    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    [self.scrollView removeFromSuperview];
    _scrollView = nil;
}


- (void)initializeView
{    
    [self updateContentSize];
    [self scrollToCurrentIndex];
}

#pragma mark - Public Methods


- (void)setPageViewControllers:(NSArray *)controllers
{
    self.viewControllers = [NSMutableArray arrayWithArray:controllers];
}


- (void)setCurrentPageIndex:(NSUInteger)index
{
    if (index > _viewControllers.count-1) {
        index = _viewControllers.count-1;
    }
    
    self.prevIndex = index;
    currentIndex = index;

    [self scrollToCurrentIndex];
}

- (void)scrollByRawIndex:(CGFloat)rawIndex
{
    CGPoint offsetPoint = CGPointMake(self.scrollView.frame.size.width + self.scrollView.frame.size.width * rawIndex, 0);
    self.scrollView.contentOffset = offsetPoint;
    [self updateCurrentIndex];
}


- (void)nextPage
{
    [self moveToIndex:self.currentIndex+1];
}

- (void)prevPage
{
    [self moveToIndex:self.currentIndex-1];
}


- (void)moveToIndex:(NSInteger)index
{    
    self.isScrolling = YES;
    
    CGFloat targetOffset = self.scrollView.frame.size.width + self.scrollView.frame.size.width * index;
    CGFloat currentOffset = self.scrollView.contentOffset.x;
    
    _moveToIndexOffsetDelta = targetOffset - currentOffset;    
    _moveToIndexOffsetStartValue = currentOffset;
    _moveToIndexStartTime = [NSDate date];
    _moveToIndexOffsetDuration = [[_moveToIndexStartTime dateByAddingTimeInterval:.666f] timeIntervalSinceDate:_moveToIndexStartTime];
    
    [_moveToIndexTimer invalidate];
    _moveToIndexTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.f target:self selector:@selector(handleMoveToIndexTick) userInfo:nil repeats:YES];
}


- (void)handleMoveToIndexTick
{
    // see what our current duration is
    CGFloat currentTime = fabsf([_moveToIndexStartTime timeIntervalSinceNow]);
    
    // stop scrolling if we are past our duration
    if (currentTime >= _moveToIndexOffsetDuration) {
        [_moveToIndexTimer invalidate];
        [self scrollToCurrentIndex];
    }
    // otherwise, calculate how much we should be scrolling our content by
    else {
        
        CGFloat delta = [self easeInOutWithCurrentTime:currentTime start:_moveToIndexOffsetStartValue change:_moveToIndexOffsetDelta duration:_moveToIndexOffsetDuration];        
        
        // this adjusts the new offset position when the delta is large enough that it should wrap 
        // back around to the beginning of the scroll view. 
        // the view then naturally adjusts to display the correct page.
        if (delta > self.scrollView.frame.size.width * .5 + self.scrollView.frame.size.width * _viewControllers.count) {
            delta -= self.scrollView.frame.size.width * _viewControllers.count;
        }
        
        // this does basically the same as the condition above, except handles the case
        // where we are going to the previous page and we need to wrap around to the end
        // of the scroll view. 
        if (delta < self.scrollView.frame.size.width * .5) {
            delta += self.scrollView.frame.size.width * _viewControllers.count;
        }
        
        self.scrollView.contentOffset = CGPointMake(delta, 0);
    }
}


#pragma mark - View Controller Management


- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    // remove previous
    for (UIViewController *vc in _viewControllers) {
        [vc.view removeFromSuperview];
    }
    
    currentIndex = 0;
    _viewControllers = [NSMutableArray arrayWithArray:viewControllers];
    
    [self initializeView];
}


- (void)initFirstViewController
{
    UIViewController *viewController = [_viewControllers objectAtIndex:0];
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}


- (void)initLastViewController
{
    UIViewController *viewController = [_viewControllers lastObject];
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.scrollView.frame.size.width * _viewControllers.count, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}


- (void)initCurrentViewController
{
    UIViewController *viewController = [_viewControllers objectAtIndex:self.currentIndex];
    [self.scrollView addSubview:viewController.view];
    viewController.view.frame = CGRectMake(self.scrollView.frame.size.width + self.currentIndex * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self loadPrevViewController];
    [self loadNextViewController];
}


- (void)loadPrevViewController
{
    UIViewController *currentVC = [self.viewControllers objectAtIndex:self.currentIndex];
    NSInteger prevIndex = [self indexOfPreviousController];
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:prevIndex];
    [self.scrollView addSubview:viewController.view];
    
    viewController.view.frame = CGRectMake(currentVC.view.frame.origin.x - self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}


- (void)loadNextViewController
{
    UIViewController *currentVC = [self.viewControllers objectAtIndex:self.currentIndex];
    NSInteger nextIndex = [self indexOfNextController];
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:nextIndex];
    [self.scrollView addSubview:viewController.view];
    
    viewController.view.frame = CGRectMake(currentVC.view.frame.origin.x + self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}


- (void)updateCurrentViewController
{    
    NSInteger delta = self.currentIndex - self.prevIndex;
    // determine if we've moved more than one index, which means we
    // need to reset to the beginning or the end of the view
    if (abs(delta) > 1) {
        if (delta < 0) {
            [self resetScrollToBeginning];
        }
        else {
            [self resetScrollToEnd];
        }
    }
    else {
        // determine which direction we are moving in, 
        // and build the upcoming view controller for that direction.
        if (self.currentIndex < self.prevIndex) {
            // moving left, backwards
            [self loadPrevViewController];
        }
        
        if (self.currentIndex > self.prevIndex) {
            // moving right, forwards
            [self loadNextViewController];
        }
    }
}


- (void)unloadUnusedViewControllers
{
    for (int i=0; i < _viewControllers.count; i++) {
        if (i != self.currentIndex && i != [self indexOfPreviousController] && i != [self indexOfNextController]) {
            UIViewController *vc = [_viewControllers objectAtIndex:i];
            if (vc.view) {
                [vc.view removeFromSuperview];
                vc.view = nil;
                [vc viewDidUnload];
            }
        }
    }
}


- (NSUInteger)indexOfPreviousController
{
    NSInteger prevIndex = self.currentIndex-1;
    if (prevIndex < 0) {
        prevIndex = self.viewControllers.count-1;
    }
    return prevIndex;
}


- (NSUInteger)indexOfNextController
{
    NSInteger nextIndex = self.currentIndex+1;
    if (nextIndex >= self.viewControllers.count) {
        nextIndex = 0;
    }
    return nextIndex;
}


- (void)layoutViews
{
    [self initCurrentViewController];
}


#pragma mark - Scroll View Management


- (void)scrollToCurrentIndex
{
    self.isScrolling = YES;
    CGPoint offsetPoint = CGPointMake(self.scrollView.frame.size.width + self.scrollView.frame.size.width * self.currentIndex, 0);
    [self.scrollView setContentOffset:offsetPoint animated:NO];
    [self initCurrentViewController];
    self.isScrolling = NO;
}


- (void)updateContentSize
{
    // the content size is extended beyond the size actually needed to display all the added view controllers.
    // we add the size of two extra pages, one for the front of the scrollview, the other for the end, to create
    // the seamless tiling effect. for example, with 10 pages, the index values would look like:
    // 9, 0, 1 ... 8, 9, 0
    CGFloat wv = (self.viewControllers.count + 2) * self.scrollView.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(wv, self.scrollView.frame.size.height);
}


- (void)updateCurrentIndex
{
    // calculate the current index and account for the extra page spaces we've added for infinite scrolling
    CGFloat rawIndex = (self.scrollView.contentOffset.x - self.scrollView.frame.size.width) / self.scrollView.frame.size.width;
    NSInteger index = roundf(rawIndex);
    
    if (index < 0) {
        index = self.viewControllers.count-1;
    }
    if (index >= _viewControllers.count) {
        index = 0;
    }
    
    self.currentIndex = index;
    
    if ([delegate respondsToSelector:@selector(infiniteScrollView:didScrollToRawIndex:)]) {
        [delegate infiniteScrollView:self didScrollToRawIndex:rawIndex];
    }
}


- (void)setCurrentIndex:(NSUInteger)newIndex
{
    if (currentIndex == newIndex) {
        return;
    }
    _prevIndex = currentIndex;
    currentIndex = newIndex;
    [self notifyDelegateOfCurrentIndexChange];
    [self updateCurrentViewController];
}


- (void)resetScrollToBeginning
{
    CGFloat offset = fmodf(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) - 1;
    self.scrollView.contentOffset = CGPointMake(offset, 0);
    [self initFirstViewController];
}


- (void)resetScrollToEnd
{
    CGFloat offset = fmodf(self.scrollView.contentOffset.x, self.scrollView.frame.size.width) - 1;
    self.scrollView.contentOffset = CGPointMake(self.viewControllers.count * self.scrollView.frame.size.width + offset, 0);
    [self initLastViewController];
}

- (void)notifyDelegateOfCurrentIndexChange
{
    if ([delegate respondsToSelector:@selector(infiniteScrollView:didScrollToIndex:)]) {
        [delegate infiniteScrollView:self didScrollToIndex:self.currentIndex];
    }
}

- (void)notifyDelegateOfOffsetChange
{
    if ([delegate respondsToSelector:@selector(infiniteScrollView:didScrollToContentOffset:)]) {
        [delegate infiniteScrollView:self didScrollToContentOffset:self.scrollView.contentOffset];
    }
}

- (void)setIsScrolling:(BOOL)scrolling
{
    if (isScrolling == scrolling) {
        return;
    }
    
    isScrolling = scrolling;
    
    if (isScrolling) {
        if ([delegate respondsToSelector:@selector(infiniteScrollViewDidBeginScrolling:)]) {
            [delegate infiniteScrollViewDidBeginScrolling:self];
        }
    }
    else {
        if ([delegate respondsToSelector:@selector(infiniteScrollViewDidEndScrolling:)]) {
            [delegate infiniteScrollViewDidEndScrolling:self];
        }
    }
}

#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    self.isScrolling = YES;
    [self updateCurrentIndex];
    [self notifyDelegateOfOffsetChange];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{    
    // this line fixes a bug that would occur after resetting the scroll view to the end,
    // quickly swiping again, and the scroll view would skip past an entire page.
    [self.scrollView setContentOffset:self.scrollView.contentOffset animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.isScrolling = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
}

/*
 static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
 return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
 }
 static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
 return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
 }
 static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
 if (t==0) return b;
 if (t==d) return b+c;
 if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
 return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
 }
 
 Easing equations taken with permission under the BSD license from Robert Penner.
 
 Copyright © 2001 Robert Penner
 All rights reserved.
 */

- (CGFloat)easeInOutWithCurrentTime:(CGFloat)t start:(CGFloat)b change:(CGFloat)c duration:(CGFloat)d
{
    if (t==0) {
        return b;
    }
    if (t==d) {
        return b+c;
    }
    if ((t/=d/2) < 1) {
        return c/2 * powf(2, 10 * (t-1)) + b;
    }
    return c/2 * (-powf(2, -10 * --t) + 2) + b;
}

@end





