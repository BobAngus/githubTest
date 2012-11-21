//
//  TudouListViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TudouListViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import "Reachability.h"
#import "TudouMvInfo.h"
#import "TodouListCell.h"
#import "EGORefreshTableHeaderView.h"

@interface TudouListViewController ()

@end

@implementation TudouListViewController
@synthesize firstLoaded;
@synthesize tuDouTableView;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//     Initialization code
//    }
//    return self;
//}

//方法类型：系统方法
//编   写：
//方法功能：
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//     Custom initialization
    }
    return self;
}

//方法类型：系统方法
//编   写：
//方法功能：调用初始化方法
- (void)viewDidLoad
{
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    tuDouTableView.backgroundView=downingImg;
    [super viewDidLoad];
//    [self wifiInfo];        //检查wifi
    [self loadHotMVData];   //加载初始数据
}

//方法类型：系统方法
//编   写：
//方法功能：资源释放
-(void)dealloc{
    [super dealloc];
    if(hotMVResult.tableViewArray)[hotMVResult.tableViewArray release];
}

//方法类型：系统方法
//编   写：
//方法功能：内存警报，资源释放
- (void)viewDidUnload
{
    [self setTuDouTableView:nil];
    [super viewDidUnload];
}

//方法类型：系统方法
//编   写：
//方法功能：手机朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//方法类型：系统方法
//编   写：
//方法功能：row Height
-(CGFloat)tableView:(UITableView *)tableView 
                        heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [hotMVResult.tableViewArray count]) {
        return 44;
    }else {
        return 110;
    }

}

//方法类型：系统方法
//编   写：
//方法功能：返回组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：返回每组行数据数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rownum = [hotMVResult.tableViewArray count];
    if (rownum > 0) {
        rownum += 1;
    }
//    NSLog(@"Row = %i",rownum);
    return rownum;
//    return [hotMVResult.tableViewArray count];
}


//方法类型：系统方法
//编   写：
//方法功能：呈现MV数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    static NSString *CellIdentifier = @"sinaTableCell";
    TodouListCell *cell = [tableView 
                           dequeueReusableCellWithIdentifier:CellIdentifier];//自定义Cell
    cell = nil;
    if (cell == nil) {
        NSArray *_nib = [[NSBundle mainBundle]loadNibNamed:@"TodouListCell" owner:self options:nil];
        cell = [_nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == [hotMVResult.tableViewArray count]) 
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) 
            {
                cell = [[[TodouListCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                             reuseIdentifier:CellIdentifier] autorelease];
                UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                moreButton.frame = CGRectMake( 79, 4, 162, 37);
                [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
                [moreButton addTarget:self action:@selector(canclehAction:) forControlEvents:UIControlEventTouchUpInside];
                [moreButton setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:moreButton];            
            }
        }
    }
    
    if (indexPath.row < [hotMVResult.tableViewArray count]) 
    {
        TudouMvInfo *tudouMvInfo = [hotMVResult.tableViewArray objectAtIndex:indexPath.row];
        
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

//方法类型：自定义方法
//编   写：
//方法功能：判断是否还有数据可加载
- (void)canclehAction:(id)sender{
    [SVProgressHUD showWithStatus:@"加载更多,请稍后..."];
    if (hotMVResult.pagesCount > hotMVResult.nowPageAt) {
        [self getMoreData];
        gettingMore=YES;
    }else {
        
        [SVProgressHUD showSuccessWithStatus:@"没有更多视频可加载!"];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：加载更多数据
-(void)getMoreData{
    if(!hotMVResult.tableViewArray){
        hotMVResult.tableViewArray=[[NSMutableArray alloc]init];
    }
    if(hotMVResult.nowPageAt < hotMVResult.pagesCount){
        hotMVResult.nowPageAt += 1;
        TudouHotMVGetter *getter = [[[TudouHotMVGetter alloc]init]autorelease];
        getter.delegate = self;
        [getter getHotMVWithPage: hotMVResult.nowPageAt];
    }else{
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:4.0];
    }
    
    [SVProgressHUD showWithStatus:@"努力加载更多..."];
    
    
}

//方法类型：自定义方法
//编   写：
//方法功能：加载完毕，刷新数据
-(void)doneLoadingTableViewData{
    gettingMore = NO;
    [SVProgressHUD showSuccessWithStatus:@"加载完毕!"];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate
//方法类型：系统方法
//编   写：
//方法功能：播放选择播放项目
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TudouMvInfo *mvinfo = nil;
    mvinfo = [hotMVResult.tableViewArray objectAtIndex:indexPath.row];
    
    NSString *url = [[NSBundle mainBundle]pathForResource:@"video" ofType:@"mp4"];
    
    MPMoviePlayerViewController *playerViewController = 
    [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];//初始化播放器
    
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
-(void)movieFinishedCallback:(MPMoviePlayerViewController*)controller
{
    
}

#pragma mark - tudou视频

//方法类型：自定义方法
//编   写：
//方法功能：加载热MV数据
-(void)loadHotMVData
{
    NSString *tempWifi = [self GetCurrntNet];
    if (![tempWifi isEqualToString:@"wifi"]) 
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"action_delete.png"] status:@"没有检查到Wifi信号"];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    if(!hotMVResult.tableViewArray){
        hotMVResult.tableViewArray=[[NSMutableArray alloc]init];
    }
    hotMVResult.nowPageAt = 1;
    TudouHotMVGetter *getter = [[[TudouHotMVGetter alloc]init]autorelease];
    getter.delegate = self;
    [getter getHotMVWithPage:1];
    
    firstLoaded = YES;                      //第一次加载
    [SVProgressHUD showWithStatus:@"努力加载中..."];
}

//方法类型：回调方法
//编   写：
//方法功能：取出xml文件的土豆排行榜信息 存入数组tudouMvInfo
-(void)downloadFinishedWithResult:(struct mvInformation)result 
                           AndKey:(NSString *)key{
    
    static BOOL firstGetted=NO;
    for (TudouMvInfo *mvinfo in result.information) {
        [hotMVResult.tableViewArray addObject:mvinfo];
    }
    hotMVResult.pagesCount = result.pagesCount;//总页数

//    if(self.view.frame.size.height < self.view.contentSize.height){

    if(gettingMore==YES){
        [self performSelector:@selector(doneLoadingTableViewData)];
    }
    if(!firstGetted){
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载完毕!"];
    }
    firstGetted=YES;
//    [self.tableView reloadData];
}
#pragma mark - Wifi
//方法类型：自定义方法
//编   写：
//方法功能：判断wifi情况给出提示
- (void)wifiInfo
{
    NSString *wifiinfo = nil;
    wifiinfo = [self GetCurrntNet];
    if (wifiinfo == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"网络检查" 
                              message:@"没有检查到可用网络" 
                              delegate:self
                              cancelButtonTitle:@"转入IPOD播放器"
                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else if (wifiinfo == @"3g") {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"网络检查" 
                              message:@"当前状态为3g网络，网络流量使用较大!是否继续使用?"
                              delegate:self 
                              cancelButtonTitle:@"转入IPOD播放器" 
                              otherButtonTitles:@"继续使用",nil];
        [alert show];
        [alert release];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：断当前信号
-(NSString*)GetCurrntNet
{
    NSString* result = nil;
    Reachability *reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:// 没有网络连接
            result=nil;
            break;
        case ReachableViaWWAN:// 使用3G网络
            result=@"3g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            result=@"wifi";
            break;
    }
    return result;
}

//方法类型：系统方法
//编   写：
//方法功能：如果没有可用wifi,则转入iPod播放器
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex]; 
    if ([buttonTitle isEqualToString:@"转入IPOD播放器"])
    {
        [SVProgressHUD showSuccessWithStatus:@""];
        [self performSegueWithIdentifier:@"ipodMusic" sender:self];
    }
}
#pragma mark - EGORefreshTableHeaderView



@end
