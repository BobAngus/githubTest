//
//  TudouSearchViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TudouSearchViewController.h"
#import "TudouSearchMVInfo.h"
#import "SVProgressHUD.h"
#import "MediaPlayer/MediaPlayer.h"

@interface TudouSearchViewController ()

@end

@implementation TudouSearchViewController
@synthesize tudouSearchBar;
@synthesize tuDouTableView;
static BOOL moreInfo = NO;
static NSString *searchStrings = @"";

//方法类型：系统方法
//编   写：
//方法功能：
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
//方法类型：系统方法
//编   写：
//方法功能：初始化数据
- (void)viewDidLoad
{
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    tuDouTableView.backgroundView=downingImg;
    [super viewDidLoad];
    searchBar = (UISearchBar *)[self.view viewWithTag:100];
    searchBar.delegate = self;
}

//方法类型：系统方法
//编   写：
//方法功能：资源释放
- (void)viewDidUnload
{
    [self setTuDouTableView:nil];
    [super viewDidUnload];
    [self setTudouSearchBar:nil];
}

//方法类型：系统方法
//编   写：
//方法功能：手机朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//方法类型：系统方法
//编   写：
//方法功能：资源释放
-(void)dealloc{
    if(searchResult.tableViewArray)[searchResult.tableViewArray release];
    [super dealloc];
}
#pragma mark - Table view data source

//方法类型：系统方法
//编   写：
//方法功能：组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：每组行数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rownum = [searchResult.tableViewArray count];
    if (rownum > 0) {
        rownum += 1;
    }
    return rownum;
}

//方法类型：系统方法
//编   写：
//方法功能：行高度
-(CGFloat)tableView:(UITableView *)tableView 
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [searchResult.tableViewArray count]) {
        return 44;
    }else {
        return 110.0f;
    }
}

//方法类型：系统方法
//编   写：
//方法功能：行数据呈现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sinaTableCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {                       
            NSArray *_nib = [[NSBundle mainBundle]loadNibNamed:@"TodouListCell" owner:self options:nil];
            cell = [_nib objectAtIndex:0];
        }
    }
    if (indexPath.row == [searchResult.tableViewArray count]) {
        NSArray *visiblecells = [self.tableView visibleCells];
        for(UITableViewCell *cell in visiblecells)
        {
            [searchResult.tableViewArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        moreButton.frame = CGRectMake( 79, 4, 162, 37);
        [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        moreButton.tag = 1;
        [moreButton addTarget:self action:@selector(canclehAction:) forControlEvents:UIControlEventTouchUpInside];
        [moreButton setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:moreButton];
    }else {
        TudouSearchMVInfo *tudouMvInfo = [searchResult.tableViewArray objectAtIndex:indexPath.row];
        UILabel *titleLable = (UILabel *)[cell viewWithTag:1];
        titleLable.text = tudouMvInfo.title;
        
        UITextView *InformationLable = (UITextView *)[cell viewWithTag:2];
        InformationLable.text = tudouMvInfo.information;
        InformationLable.scrollEnabled = YES; 
        InformationLable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        InformationLable.backgroundColor = [UIColor clearColor];
        
        UIImageView *pictureImage = (UIImageView *)[cell viewWithTag:3];
        pictureImage.image = tudouMvInfo.picture;
    }
    return cell;
}



#pragma mark - Table view delegate
//方法类型：系统方法
//编   写：
//方法功能：选择行，播放mv
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TudouSearchMVInfo *mvinfo = nil;
    mvinfo = [searchResult.tableViewArray objectAtIndex:indexPath.row];
    
    NSString *url = [[NSBundle mainBundle]pathForResource:@"video" ofType:@"mp4"];
    
    MPMoviePlayerViewController *playerViewController = 
    [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];//初始化播放器
    
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(movieFinishedCallback:) 
                                                name:MPMoviePlayerPlaybackDidFinishNotification 
                                              object:[playerViewController moviePlayer]];//设置监听
    
    [playerViewController.view setFrame:CGRectMake(0, -20, 320, 480)];
    
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    NSURL *tempUrl = [NSURL URLWithString:mvinfo.playURL];
    [player setContentURL:tempUrl];
    [player play];
    
    [self presentModalViewController:playerViewController animated:YES]; 
}

//方法类型：系统方法
//编   写：
//方法功能：当点击Done时发生
-(void)movieFinishedCallback:(MPMoviePlayerViewController*)controller{
    
}
#pragma mark - search bar delegate methods

//方法类型：自定义方法
//编   写：
//方法功能：搜索按钮 取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBars{
    //	[self doSearch:searchBars];
}

//方法类型：自定义方法
//编   写：
//方法功能：键盘搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars{
	[searchBars resignFirstResponder];
	[self doSearch:searchBars];
}

//方法类型：自定义方法
//编   写：
//方法功能：搜索方法
- (void)doSearch:(UISearchBar *)searchBars{
    NSString *searchString = searchBars.text;
    
    searchStrings = searchString;
    searchResult.tableViewArray = [[NSMutableArray alloc]init];
    searchResult.nowPageAt = 1;
    
    TudouHotMVGetter *getter = [[[TudouHotMVGetter alloc]init]autorelease];
    getter.delegate = self;
    [getter searchByString:searchString AndPage:1];
    
    [SVProgressHUD showWithStatus:@"正在搜索,请稍后..."];
}

#pragma mark - 加载更多
//方法类型：自定义方法
//编   写：
//方法功能：加载更多
- (void)canclehAction:(id)sender{
    moreInfo = YES;
    [SVProgressHUD showWithStatus:@"加载更多,请稍后..."];
    NSLog(@"%i > %i",searchResult.pagesCount,searchResult.nowPageAt);
    if (searchResult.pagesCount > searchResult.nowPageAt) {
        [self getMoreData];
    }else {
        
        [SVProgressHUD showSuccessWithStatus:@"没有更多视频可加载!"];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：获取数据
-(void)getMoreData{
    if(!searchResult.tableViewArray)
    {
        searchResult.tableViewArray=[[NSMutableArray alloc]init];
    }
    if(searchResult.nowPageAt < searchResult.pagesCount)
    {
        searchResult.nowPageAt+=1;
        TudouHotMVGetter *getter=[[[TudouHotMVGetter alloc]init]autorelease];
        getter.delegate=self;
        [getter getHotMVWithPage:searchResult.nowPageAt];
    }
    else
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:4.0];
    }
}
#pragma mark - download

//方法类型：自定义方法
//编   写：
//方法功能：搜索数据
-(void)downloadFinishedWithResult:(struct mvInformation)result AndKey:(NSString *)key{
    if (!moreInfo) {
        [searchResult.tableViewArray removeAllObjects];//删除所有对象
    }
    for (TudouSearchMVInfo *info in result.information) {
        [searchResult.tableViewArray addObject:info];
    }
    
    searchResult.pagesCount = result.pagesCount;
    [SVProgressHUD showSuccessWithStatus:@"搜索完成!"];
    [tudouSearchBar setText:searchStrings];//过滤
}

@end
