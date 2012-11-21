//
//  OpeningViewController.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "OpeningViewController.h"

@interface OpeningViewController ()

@end

@implementation OpeningViewController
@synthesize gotoMainViewBtn = _gotoMainViewBtn;

@synthesize imageView;
@synthesize left = _left;
@synthesize right = _right;
@synthesize pageScroll;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//方法类型：系统方法
//编   写：
//方法功能：初始化，设置动画页数
- (void)viewDidLoad
{
    [super viewDidLoad];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageScroll.delegate = self;
    
    pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setGotoMainViewBtn:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//方法类型：系统方法
//编   写：
//方法功能：动画结束，转入MainStoryboard
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"split"] && finished) {
        
        [self.left removeFromSuperview];
        [self.right removeFromSuperview];
        UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        [self presentModalViewController:controller animated:YES];
    }  
}

//方法类型：自定义方法
//编   写：
//方法功能：进入应用
- (IBAction)gotoMainView:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [self.gotoMainViewBtn setHidden:YES];
    NSArray *array = [UIImage splitImageIntoTwoParts:self.imageView.image];
    self.left = [[UIImageView alloc] initWithImage:[array objectAtIndex:0]];
    self.right = [[UIImageView alloc] initWithImage:[array objectAtIndex:1]];
    [self.view addSubview:self.left];
    [self.view addSubview:self.right];
    [self.pageScroll setHidden:YES];
    [self.pageControl setHidden:YES];
    self.left.transform = CGAffineTransformIdentity;
    self.right.transform = CGAffineTransformIdentity;
    
    [UIView beginAnimations:@"split" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.left.transform = CGAffineTransformMakeTranslation(-160 ,0);
    self.right.transform = CGAffineTransformMakeTranslation(160 ,0);   
    [UIView commitAnimations];
    
}

//方法类型：自定义方法
//编   写：
//方法功能：划动加载下一页
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

//方法类型：系统方法
//编   写：
//方法功能：手机朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
