//
//  GDIInfiniteScrollView.h
//  GDI-InfiniteScrollView
//
//  Created by Grant Davis on 2/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDIInfinitePageScrollViewControllerDelegate;

@interface GDIInfinitePageScrollViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *pageViewControllers;
@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (weak, nonatomic) NSObject <GDIInfinitePageScrollViewControllerDelegate> *delegate;
@property (nonatomic) BOOL isScrolling;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (void)setCurrentPageIndex:(NSUInteger)index;
- (void)scrollByRawIndex:(CGFloat)rawIndex;
- (void)nextPage;
- (void)prevPage;

@end


@protocol GDIInfinitePageScrollViewControllerDelegate
@optional
- (void)infiniteScrollViewDidBeginScrolling:(GDIInfinitePageScrollViewController *)scrollViewController;
- (void)infiniteScrollViewDidEndScrolling:(GDIInfinitePageScrollViewController *)scrollViewController;
- (void)infiniteScrollView:(GDIInfinitePageScrollViewController *)scrollViewController didScrollToContentOffset:(CGPoint)offset;
- (void)infiniteScrollView:(GDIInfinitePageScrollViewController *)scrollViewController didScrollToIndex:(NSUInteger)index;
- (void)infiniteScrollView:(GDIInfinitePageScrollViewController *)scrollViewController didScrollToRawIndex:(CGFloat)index; // decimal value of the position of the view.
@end