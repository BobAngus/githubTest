//
//  IPodMusicPlayerViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IPodMusicPlayerManager.h"
#import "GDIInfinitePageScrollViewController.h"
#import "PlaylistViewController.h"
#import "AlbumCover.h"
#import "Lyrics.h"
#import "GlobalMusicList.h"
//#import "DFOnlinePlayer.h"

@interface IPodMusicPlayerManager ()

@end

@implementation IPodMusicPlayerManager
@synthesize imageplayMode;
@synthesize imageAddGrouping;
@synthesize playOrPause;
@synthesize playOrPauseInfo;
@synthesize songTitle;
@synthesize singerName;
@synthesize duration;
@synthesize totaltime;
@synthesize sliderPlay;
@synthesize musicPlayer;
@synthesize mediaCollection;
@synthesize StorageMusicName;
PlaylistViewController *gdi1;
AlbumCover *gdi2;
Lyrics *gdi3;


NSTimer *paylTotalTimer;

//方法类型：系统方法
//编   写：
//方法功能：viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self pageScroll];
    
    if (!self.musicPlayer) {//如果没有初始化，那么设置ipod播放器
        self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        [self registerForMediaPlayerNotifications];
    }
    [self handle_NowPlayingItemChanged];
    [self handle_PlaybackStateChanged];
}

//方法类型：自定义方法
//编   写：
//方法功能：初始化播放器
-(id)initWithPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList{
    self = [super init];
	if(self)
	{
		switch (PlayerType)
		{
			case 0:
				self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
				if([SongList count] > 0)
				{
					MPMediaItemCollection *_mediaCollection = [[MPMediaItemCollection alloc]initWithItems:SongList];
					self.mediaCollection = _mediaCollection;
					[_mediaCollection release];
					
					[self.musicPlayer setQueueWithItemCollection:mediaCollection];
					[self.musicPlayer setRepeatMode:MPMusicRepeatModeAll];
					
				}
				else
				{
					[self.musicPlayer setQueueWithItemCollection:nil];
					[self.musicPlayer setRepeatMode:MPMusicRepeatModeAll];
				}
				break;
				
			case 1:
				self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
				if([SongList count] > 0)
				{
					MPMediaItemCollection *_mediaCollection = [[MPMediaItemCollection alloc]initWithItems:SongList];
					mediaCollection = _mediaCollection;
					[_mediaCollection release];
					
					[musicPlayer setQueueWithItemCollection:mediaCollection];
					[musicPlayer setRepeatMode:MPMusicRepeatModeAll];
					[self registerForMediaPlayerNotifications];
				}
				else
				{
					[musicPlayer setQueueWithItemCollection:mediaCollection];
					[musicPlayer setRepeatMode:MPMusicRepeatModeAll];
				}
				break;
		}
	}
	return self;
}


//方法类型：系统方法
//编   写：
//方法功能：资源释放
- (void)dealloc{
    [super dealloc];
    [self.StorageMusicName release];
    [self.musicPlayer release];
	[self.mediaCollection release];
}

- (void)viewDidUnload
{
    [self setSongTitle:nil];
    [self setSingerName:nil];
    [self setDuration:nil];
    [self setTotaltime:nil];
//    [self setSliderPlay:nil];
    [self setImageplayMode:nil];
    [self setImageAddGrouping:nil];
    [self setImageplayMode:nil];
    [self setPlayOrPause:nil];
    [self setPlayOrPauseInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//方法类型：系统方法
//编   写：
//方法功能：手机转向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//方法类型：自定义方法
//编   写：
//方法功能：重置播放容器
- (void)reload:(NSMutableArray *)SongList
{
	if([SongList count] > 0)
	{
		MPMediaItemCollection *_mediaCollection = [[MPMediaItemCollection alloc]initWithItems:(NSArray *)SongList];
		self.mediaCollection = _mediaCollection;
        if ([[GlobalMusicList sharedSingleton].GmediaItemCList count] > 0) {
            [GlobalMusicList sharedSingleton].GmediaItemCList = nil;
            [GlobalMusicList sharedSingleton].GNSMusicListName = @"";
        }
        [GlobalMusicList sharedSingleton].GmediaItemCList = _mediaCollection;
        
        NSString *tempStorage ;
        if (StorageMusicName) 
        {
            tempStorage = [NSString stringWithFormat:@"%@",self.StorageMusicName];
            tempStorage=[tempStorage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去空白
        }
        [GlobalMusicList sharedSingleton].GNSMusicListName = tempStorage;
		[_mediaCollection release];
		[self.musicPlayer setQueueWithItemCollection:mediaCollection];
	}
}

//方法类型：自定义方法
//编   写：
//方法功能：初始化播放器附带View
- (void)pageScroll
{
    gdi1 = [[PlaylistViewController alloc]
                                    initWithNibName:@"PlaylistViewController" bundle:nil];
    gdi2 = [[AlbumCover alloc]
                        initWithNibName:@"AlbumCover" bundle:nil];
    gdi3 = [[Lyrics alloc]
                    initWithNibName:@"Lyrics" bundle:nil];
    
    
    
    GDIInfinitePageScrollViewController *infiniteScrollerVC = [[GDIInfinitePageScrollViewController alloc]initWithViewControllers:[NSArray arrayWithObjects:gdi2,gdi1,gdi3,nil]];
    [self.view addSubview:infiniteScrollerVC.view];
    [infiniteScrollerVC.view setFrame:CGRectMake(0, 44, 320, 320)];
}

//方法类型：自定义方法 ipodsygq
//编   写：
//方法功能：播放
- (void)play
{
	[musicPlayer play];
    if (gdi1) {
//        gdi1.musicListView.layoutSubviews
        
    }
    if (gdi2) {
        gdi2.artworkImage.image = [UIImage imageNamed: @"no_album.png"];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：暂停音乐
- (void)pause
{
	[musicPlayer pause];
}

//方法类型：自定义方法
//编   写：
//方法功能：停止音乐
- (void)stop
{
	[musicPlayer stop];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放上一曲
- (void)prev
{
	[musicPlayer skipToPreviousItem];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放下一曲
- (void)next
{
	[musicPlayer skipToNextItem];
}

//方法类型：自定义方法
//编   写：
//方法功能：清空播放容器
- (void)clearMusicPlayer
{
	self.mediaCollection = nil;
	[self.musicPlayer setQueueWithItemCollection:nil];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放
- (void)saveToData
{
    NSString *tempStorage ;
    if (self.StorageMusicName == @"mrlb") 
    {
        tempStorage = [NSString stringWithFormat:@"%@",self.StorageMusicName];
        tempStorage=[tempStorage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去空白
    }else if(self.StorageMusicName == @"zjbf") 
    {
        tempStorage = [NSString stringWithFormat:@"%@",self.StorageMusicName];
        tempStorage=[tempStorage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去空白
    }else if(self.StorageMusicName == @"wzat") 
    {
        tempStorage = [NSString stringWithFormat:@"%@",self.StorageMusicName];
        tempStorage=[tempStorage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去空白
    }
    
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self.mediaCollection items]];
	[[NSUserDefaults standardUserDefaults]setObject:data forKey:tempStorage];
	[[NSUserDefaults standardUserDefaults]synchronize];

}

//方法类型：自定义方法
//编   写：
//方法功能：播放模式
- (IBAction)playMode:(id)sender 
{  
    if (self.musicPlayer.repeatMode == MPMusicRepeatModeNone) 
    {
        [self.musicPlayer setRepeatMode:MPMusicRepeatModeOne];      //单曲
        [imageplayMode setImage:[UIImage imageNamed:@"AudioPlayerRepeatOneOn.png"] forState:UIControlStateNormal];
        [self.playOrPauseInfo setText:@"单曲循环"];
    }
    else if (self.musicPlayer.repeatMode == MPMusicRepeatModeOne)  
    {
        [self.musicPlayer setRepeatMode:MPMusicRepeatModeAll];      //全部
        [imageplayMode setImage:[UIImage imageNamed:@"AudioPlayerRepeatOn.png"] forState:UIControlStateNormal];
        [self.playOrPauseInfo setText:@"全部循环"];
    }
    else if (self.musicPlayer.repeatMode == MPMusicRepeatModeAll)  
    {
        [self.musicPlayer setRepeatMode:MPMusicRepeatModeNone];  //无
        [imageplayMode setImage:[UIImage imageNamed:@"AudioPlayerRepeatOff.png"] forState:UIControlStateNormal];
        [self.playOrPauseInfo setText:@"无循环"];
    }
    [self.playOrPauseInfo setAlpha:1.0];
    [self performSelector:@selector(playOrPauseInfoAlpha) withObject:nil afterDelay:3];
    //setRepeatMode
//    imageplayMode
}

//方法类型：自定义方法
//编   写：
//方法功能：取消播放模式提醒
-(void)playOrPauseInfoAlpha
{
    [self.playOrPauseInfo setAlpha:0.0];
}

//方法类型：自定义方法
//编   写：
//方法功能：页面播放按钮
- (IBAction)managerPlayer:(id)sender 
{    
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) 
    {
        [self.playOrPause setStyle:UIBarButtonSystemItemPause];
        [self pause];
    }else {
        [self.playOrPause setStyle:UIBarButtonSystemItemPlay];
        [self play];
    }
    [self handle_NowPlayingItemChanged];
}

//方法类型：自定义方法
//编   写：
//方法功能：页面上一曲
- (IBAction)skipToPreviousItem:(id)sender 
{
    [self.musicPlayer skipToPreviousItem];
}

//方法类型：自定义方法
//编   写：
//方法功能：页面下一曲
- (IBAction)skipToNextItem:(id)sender 
{
    [self.musicPlayer skipToNextItem];
}

//方法类型：自定义方法
//编   写：
//方法功能：添加收藏分组
- (IBAction)addGrouping:(id)sender 
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：注册通知
- (void) registerForMediaPlayerNotifications 
{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_NowPlayingItemChanged)
							   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object: musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: musicPlayer];
    
    /*
     // 此示例不使用图书馆学变化的通知，这个代码是在这里显示它是如何做，如果你需要它。
     [notificationCenter addObserver: self
     selector: @selector (handle_iPodLibraryChanged:)
     name: MPMediaLibraryDidChangeNotification
     object: musicPlayer];
     
     [[MPMediaLibrary defaultMediaLibrary] beginGeneratingLibraryChangeNotifications];
     */
    [musicPlayer beginGeneratingPlaybackNotifications];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放曲目改变时处理方法
- (void)handle_NowPlayingItemChanged
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];//获得正在播放的项目
    if (currentItem) {
        self.songTitle.text = [currentItem valueForProperty:MPMediaItemPropertyTitle];//歌曲名称
        self.singerName.text = [currentItem valueForProperty:MPMediaItemPropertyArtist];//歌手

//        albumTitle = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle]; //获取专辑标题 
    }
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImages = [artwork imageWithSize:CGSizeMake(320, 320)];
    if (artworkImages) {
        gdi2.artworkImage.image = (UIImage *)artworkImages;      
    } else {        
        gdi2.artworkImage.image = [UIImage imageNamed: @"no_album.png"];    
    }
    gdi3.textLyrics.text = @"歌词显示 歌词显示\n歌词显示\n歌词显示\n歌词显示\n歌词显示\n歌词显示\n歌词显示\n歌词显示\n歌词显示\n";
    gdi2.LMusicLyrics.text = @"";//歌词
    
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) 
    {
        [self.playOrPause setStyle:UIBarButtonSystemItemPause];
    }else 
    {
        [self.playOrPause setStyle:UIBarButtonSystemItemPlay];
    }
    
    if (self.musicPlayer.repeatMode == MPMusicRepeatModeNone) 
    {
        //无
        [imageplayMode setImage:[UIImage imageNamed:@"AudioPlayerRepeatOff.png"] forState:UIControlStateNormal];
    }
    else if (self.musicPlayer.repeatMode == MPMusicRepeatModeOne)  
    {
        //单曲
        [imageplayMode setImage:[UIImage imageNamed:@"AudioPlayerRepeatOneOn.png"] forState:UIControlStateNormal];        
    }
    else if (self.musicPlayer.repeatMode == MPMusicRepeatModeAll)  
    {
        //全部
        [imageplayMode setImage:[UIImage imageNamed:@"AudioPlayerRepeatOn.png"] forState:UIControlStateNormal];
    }
    
    
//    [self startPlayWithMusicCollection];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放曲目状态改变时处理方法
- (void)handle_PlaybackStateChanged
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	if (playbackState == MPMusicPlaybackStatePlaying) {
        paylTotalTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f 
                                                        target:self 
                                                      selector:@selector(timerGoes:) 
                                                      userInfo:nil 
                                                       repeats:YES];
 
        [self updateSliderWithValue:0.0f TimeGoes:@"00:00" readyTime:@"-00:00"];        
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        [paylTotalTimer invalidate];
        paylTotalTimer = nil;
        self.duration.text = @"0:00";
        self.totaltime.text = @"0:00";
        
        //即使停了下来，调用“停止”，确保从一开始的音乐播放器将发挥其队列。
		[musicPlayer stop];
	}
}
//方法类型：自定义方法
//编   写：
//方法功能：判断播放曲目状态，改变当前播放时间显示
-(void)timerGoes:(NSTimer*)sender
{
    if(self.musicPlayer.playbackState==MPMusicPlaybackStateStopped){
        [paylTotalTimer invalidate];
        paylTotalTimer=nil;        
    }else{
        float timeGoes=self.musicPlayer.currentPlaybackTime;
        float readyTime=[[self.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration]floatValue];
        float result=timeGoes/readyTime;
        [self updateSliderWithValue:result 
                           TimeGoes:[self timeStringWithNumber:(int)timeGoes] 
                          readyTime:[NSString stringWithFormat:@"-%@",
                                     [self timeStringWithNumber:(int)readyTime
                                      - (int)timeGoes]]];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：修改当前播放进度显示
-(void)updateSliderWithValue:(float)value TimeGoes:(NSString *)goesTime readyTime:(NSString *)readyTime
{
    sliderPlay.value=value;
    [duration setText:goesTime];
    [totaltime setText:readyTime];
}

//方法类型：自定义方法
//编   写：
//方法功能：转换时间显示格式
-(NSString*)timeStringWithNumber:(float)theTime
{
    NSString *minuteS=[NSString string];
    
    int minute=(theTime)/60;
    if(theTime<60){
        minuteS=[NSString stringWithString:@"00"];
    }else if(minute<10){
        minuteS=[NSString stringWithFormat:@"0%i",(minute)];
    }else{
        minuteS=[NSString stringWithFormat:@"%i",(minute)];
    }
    
    NSString *playTimeS=[NSString string];
    if(theTime-60*minute<10){
        playTimeS=[NSString stringWithFormat:@"%@:0%0.0f",minuteS,theTime-60*minute];
    }else{
        playTimeS=[NSString stringWithFormat:@"%@:%0.0f",minuteS,theTime-60*minute];
    }
    return playTimeS;    
}

@end
