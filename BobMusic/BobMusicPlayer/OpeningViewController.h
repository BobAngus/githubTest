//
//  OpeningViewController.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+SplitImageIntoTwoParts.h"

@interface OpeningViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) UIImageView *left;
@property (nonatomic,strong) UIImageView *right;

@property (retain, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)gotoMainView:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *gotoMainViewBtn;
@end
