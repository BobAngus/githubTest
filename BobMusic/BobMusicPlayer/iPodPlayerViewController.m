//
//  iPodPlayerViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IPodPlayerViewController.h"
#import "GlobalMusicList.h"
#import "MusiciCarouselViewController.h"
#import "GlobalDownloadMusic.h"
#import "GlobalMusicPlayRow.h"

@interface iPodPlayerViewController ()

@end

@implementation iPodPlayerViewController

@synthesize musicPlayerManager;
@synthesize musicListName;
@synthesize musicListView;

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
//    if ([GlobalDownloadMusic sharedSingleton].avaPlayer.playing) 
//    {
//        [[GlobalDownloadMusic sharedSingleton].avaPlayer pause];
//        [[GlobalDownloadMusic sharedSingleton] timePause];
//    }
//    if ([GlobalMusicPlayRow sharedSingleton].streamer)
//    {
//        if ([[GlobalMusicPlayRow sharedSingleton].streamer isPlaying]) 
//        {
//            [[GlobalMusicPlayRow sharedSingleton].streamer pause];;
//        }
//    }
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    musicListView.backgroundView=downingImg;
    if (self.musicListName == @"mrlb") 
    {
        self.navigationItem.title = @"默认列表";
    }
    else if (self.musicListName == @"zjbf") 
    {
        self.navigationItem.title = @"最近播放";
    }
    else if (self.musicListName == @"wzat") 
    {
        self.navigationItem.title = @"我最爱听";
    }
    if (!musicPlayerManager) 
    {
        musicPlayerManager = [[IPodMusicPlayerManager alloc]initWithPlayerType:1 LoadSong:nil];
    }
    musicPlayerManager.StorageMusicName = self.musicListName;//播放列表 必须
	[self performSelector:@selector(initialMusicList)];
    [super viewDidLoad];
}

//方法类型：系统方法
//编   写：
//方法功能：资源释放
- (void)viewDidUnload
{
    //    [musicPlayerManager stop];
    //	musicPlayerManager = nil;
    
    musicListView = nil;
    [self setMusicListView:nil];
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
//方法功能：返回组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：返回每组中保护的行数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([musicPlayerManager.mediaCollection count] > 0) {
        return [musicPlayerManager.mediaCollection count] + 1;
    }else {
        return 1;
    }
}

//方法类型：系统方法
//编   写：
//方法功能：呈现行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"musicListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        if (indexPath.row == 0) 
        {
            if (self.musicListName == @"mrlb") 
            {
                UILabel *row = (UILabel *)[cell viewWithTag:220];
                row.text = @"";
                
                UILabel *musicNmae = (UILabel *)[cell viewWithTag:221];
                musicNmae.textAlignment = UITextAlignmentCenter;
                musicNmae.font = [UIFont boldSystemFontOfSize:20];
                musicNmae.text =@"添加更多";
                UILabel *symbol = (UILabel *)[cell viewWithTag:222];
                symbol.text = @"";
            }
        }
        
    }
    if (indexPath.row > 0){
        
        UILabel *row = (UILabel *)[cell viewWithTag:220];
        row.text = [NSString stringWithFormat:@"%d 、",indexPath.row];
        
        UILabel *musicNmae = (UILabel *)[cell viewWithTag:221];
        musicNmae.textAlignment = UITextAlignmentLeft;
        musicNmae.text = [[[musicPlayerManager.mediaCollection items]objectAtIndex:indexPath.row -1]valueForProperty:MPMediaItemPropertyTitle];
        
        UILabel *symbol = (UILabel *)[cell viewWithTag:222];
        symbol.text = @"";
    }
    
    return cell;
}


#pragma mark - Table view delegate
//方法类型：系统方法
//编   写：
//方法功能：用户选择播放音乐或者选择第一行添加音乐
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MusiciCarouselViewController *objectMusic = [[MusiciCarouselViewController alloc]init];
//    objectMusic.playerAvAOrIpod = YES;
    if (indexPath.row == 0) 
    {
        [self refresh];
    }
    else 
    {
        if (musicPlayerManager.musicPlayer.playbackState == MPMoviePlaybackStatePlaying) 
        {
            [musicPlayerManager pause];
        }
        [musicPlayerManager.musicPlayer setNowPlayingItem:[[musicPlayerManager.mediaCollection items]objectAtIndex:indexPath.row - 1]];
        
        if ([[GlobalMusicList sharedSingleton].GmediaItemCList count] > 0) 
        {
            [GlobalMusicList sharedSingleton].GmediaItemCList = nil;
            [GlobalMusicList sharedSingleton].GNSMusicListName = @"";
        }
        [GlobalMusicList sharedSingleton].GmediaItemCList = musicPlayerManager.mediaCollection;
        [GlobalMusicList sharedSingleton].GNSMusicListName = self.musicListName;  
        [musicPlayerManager.musicPlayer play];   
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
//	[self performSegueWithIdentifier:@"ipodMusic" sender:self];  //跳转播放页面
}

#pragma mark - MPMediaPickerController delegate
//方法类型：自定义方法
//编   写：
//方法功能：从ipod库中读取播放列表
- (void)refresh
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc]
                                            initWithMediaTypes:MPMediaTypeMusic]; 
    if (mediaPicker != nil)
    {
        mediaPicker.delegate = self; 
        mediaPicker.allowsPickingMultipleItems = YES;
        [self.navigationController presentModalViewController:mediaPicker animated:YES];
    } 
    else 
    {
        [[[UIAlertView alloc] initWithTitle:@"媒体选择器" 
                            message:@"媒体选择器初始化失败!" 
                           delegate:nil 
                  cancelButtonTitle:@"ok" 
                  otherButtonTitles:nil]show];
    } 

}

//方法类型：系统方法
//编   写：
//方法功能：添加ipod库音乐
- (IBAction)refresh:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc]
                                            initWithMediaTypes:MPMediaTypeMusic]; 
    if (mediaPicker != nil)
    {
        mediaPicker.delegate = self; 
        mediaPicker.allowsPickingMultipleItems = YES;
        [self.navigationController presentModalViewController:mediaPicker animated:YES];
    }
    else 
    {
        UIAlertView *alertViewMessage =[[UIAlertView alloc] initWithTitle:@"媒体选择器" 
                                                                  message:@"媒体选择器初始化失败!" 
                                                                 delegate:nil 
                                                        cancelButtonTitle:@"ok" 
                                                        otherButtonTitles:nil];
        [alertViewMessage show];
    } 
}


//方法类型：系统方法
//编   写：
//方法功能：未选择音乐离开
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [mediaPicker dismissModalViewControllerAnimated:YES];
}

//方法类型：自定义方法
//编   写：
//方法功能：判断是否有存储过的音乐
- (void)initialMusicList
{
	if([[NSUserDefaults standardUserDefaults]objectForKey:musicListName])
    {
        [musicPlayerManager reload:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:musicListName]]];
    }
	[musicListView reloadData];
}


//方法类型：系统方法
//编   写：
//方法功能：选择音乐，进行处理
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    BOOL isADD = NO;
	NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[musicPlayerManager.mediaCollection items]];
	
	for(MPMediaItem *item in [mediaItemCollection items])
	{
		if([tempArray containsObject:item] == NO)//判断所选择音乐是否有添加过
		{
			[tempArray addObject:item];
			isADD = YES;
		}
	}
	if(isADD)
	{
		[musicPlayerManager stop];
		[musicPlayerManager reload:tempArray];
		[musicPlayerManager saveToData];
		[musicListView reloadData];
	}
	tempArray = nil;
	[mediaPicker dismissModalViewControllerAnimated: YES];//释放选择器         
//    [self performSegueWithIdentifier:@"musicPlayer" sender:self];  //跳转播放页面
}
//方法类型：系统方法 
//编   写：
//方法功能：跳转之前设置数据 
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
//{
////    MusiciCarouselViewController *objectMusic = (MusiciCarouselViewController*)segue.destinationViewController;
//    objectMusic.playerAvAOrIpod = YES;
//}
@end
