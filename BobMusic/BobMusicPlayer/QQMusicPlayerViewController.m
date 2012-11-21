//
//  QQMusicPlayerViewController.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/CoreAnimation.h>
#import "QQMusicPlayerViewController.h"
#import "QQMusicSongSingleInfo.h"
#import "GlobalMusicPlayRow.h"
#import "SVProgressHUD.h"
#import "SongLrcDownload.h"
#import "Reachability.h"
#import "GlobalDownloadMusic.h"

@interface QQMusicPlayerViewController ()
{
    CGRect currentRect;
    NSUInteger index;
}
@end

@implementation QQMusicPlayerViewController

@synthesize ialbumLarge;
@synthesize ialbumSmall;
@synthesize pmusicPlayTime;
@synthesize iMusicPlaySchedule;
@synthesize iMusicPlaySurplus;
@synthesize lSongName;
@synthesize lSingerName;
@synthesize lAlbumName;
@synthesize backScrollView;
@synthesize selectedLabel;
@synthesize lrcLabel;
@synthesize mnewSongListViewController;

@synthesize activeDownload;
@synthesize imageConnection;
@synthesize imageURLString;

NSString *musicUrl;         //音乐链接地址
BOOL isPlayOrPause = YES;   //判断是否手动暂停或播放
BOOL showTips = NO;         //播放状态改变，是否显示图标
BOOL isLyrics = YES;          //是否有歌词

//方法类型：系统方法
//编   写：
//方法功能：
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
//方法功能：初始化 左扫 右扫 上扫 下扫 点击 手势 调用musicPlayRow方法判断是否初次进入并处理，
- (void)viewDidLoad
{
//    musicLrc.backgroundColor = [UIColor clearColor]; 
    if ([GlobalDownloadMusic sharedSingleton].avaPlayer.playing) 
    {
        [[GlobalDownloadMusic sharedSingleton].avaPlayer pause];
        [[GlobalDownloadMusic sharedSingleton] timePause];
    }
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    swipeLeft.delegate = self;
    [swipeLeft release];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    swipeRight.delegate = self;
    [swipeRight release];
    
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    swipeDown.delegate = self;
    [swipeDown release];

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    swipeUp.delegate = self;
    [swipeUp release];
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    [self.view addGestureRecognizer:singleFingerOne];
    [singleFingerOne release];
    mnewSongListViewController = [[NewSongListViewController alloc]init];
    self.backScrollView.scrollEnabled = NO;
    [ialbumSmall setImage:[[ialbumLarge image] reflectionWithAlpha:0.8]];
    NSString *tempWifi = [self GetCurrntNet];
    if (![tempWifi isEqualToString:@"wifi"]) 
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"action_delete.png"] status:@"没有检查到Wifi信号"];
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    [self musicPlayRow];
    [super viewDidLoad];
}

//方法类型：系统方法
//编   写：
//方法功能：视图即将可见时，开始接收远程控制事件
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

//方法类型：系统方法
//编   写：
//方法功能：远程事件处理(播放器 播放、暂停、上、下一曲)
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playOrPause];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self skipToPreviousItem]; 
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self skipToNextItem];
                break;
                
            default:
                break;
        }
    }
}
//方法类型：系统方法
//编   写：
//方法功能：视图被驳回时调用，覆盖或以其他方式隐藏时，结束远程控制事件
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [self becomeFirstResponder];
} 

//方法类型：系统方法
//编   写：
//方法功能：使becomeFirstResponder可返回YES,使其成为第一响应者
- (BOOL) canBecomeFirstResponder  
{
    return YES;  
}


//方法类型：系统方法
//编   写：
//方法功能：musicPlayRow方法判断是否初次进入并处理
- (void)musicPlayRow
{
    if ([GlobalMusicPlayRow sharedSingleton].musicPlayRow != 0) 
    {
        if ([GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow != 0) 
        {
            if ([GlobalMusicPlayRow sharedSingleton].musicPlayRow != [GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow) 
            {
                if ([[GlobalMusicPlayRow sharedSingleton].streamer isPlaying]) 
                {
                    [[GlobalMusicPlayRow sharedSingleton].streamer stop];
                    [GlobalMusicPlayRow sharedSingleton].playStatus = NO;
                    [[GlobalMusicPlayRow sharedSingleton].streamer release];
                    [GlobalMusicPlayRow sharedSingleton].streamer = nil;
                }
                [GlobalMusicPlayRow sharedSingleton].musicPlayRow = [GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow;
                [self playQQMusic:([GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow)];
                
            }
        }
        [GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow = 0;
    }
    else
    {
        if (![GlobalMusicPlayRow sharedSingleton].playStatus) 
        {
            [self playQQMusic:([GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow)];
            [GlobalMusicPlayRow sharedSingleton].musicPlayRow = [GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow;
            [GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow = 0;
        }
    }
    [self loadedAgain];
}

//方法类型：系统方法
//编   写：
//方法功能：内存警告，释放资源
- (void)viewDidUnload
{
    [self setIalbumLarge:nil];
    [self setIalbumSmall:nil];
    [self setPmusicPlayTime:nil];
    [self setIMusicPlaySchedule:nil];
    [self setIMusicPlaySurplus:nil];
    [self setLSongName:nil];
    [self setLSingerName:nil];
    [self setLAlbumName:nil];
    [self setBackScrollView:nil];
    [self setSelectedLabel:nil];
    [self setLrcLabel:nil];
    
    [super viewDidUnload];
}

//方法类型：系统方法
//编   写：
//方法功能：释放资源
- (void)dealloc
{
    [activeDownload release];
    [imageConnection cancel];
    [imageConnection release];
    [ialbumLarge release];
    [ialbumSmall release];
    [pmusicPlayTime release];
    [iMusicPlaySchedule release];
    [iMusicPlaySurplus release];
    [lSongName release];
    [lSingerName release];
    [lAlbumName release];
    [super dealloc];
}


//方法类型：系统方法
//编   写：
//方法功能：设置手机朝向，去掉顶部状态栏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//方法类型：自定义方法
//编   写：
//方法功能：右扫手势
-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer 
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        showTips = YES;
        [self skipToPreviousItem];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：左扫手势
-(void) swipeLeft:(UISwipeGestureRecognizer *) recognizer 
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        showTips = YES;
        [self skipToNextItem];
    }
}
//方法类型：自定义方法
//编   写：
//方法功能：上滑手势
-(void)swipeDown:(UISwipeGestureRecognizer *) recognizer
{
    [self dismissModalViewControllerAnimated:YES];
}

//方法类型：自定义方法
//编   写：
//方法功能：上滑手势,显示或隐藏歌词
-(void)swipeUp:(UISwipeGestureRecognizer *) recognizer
{
    if (self.backScrollView.alpha == 0) 
    {
        self.ialbumLarge.alpha = 0.3;
        self.backScrollView.alpha = 1;
    }
    else
    {
        self.backScrollView.alpha = 0;
        self.ialbumLarge.alpha = 1;
    }
}

//方法类型：系统方法
//编   写：
//方法功能：解除部分被点击事件控制的控件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) 
    {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[UIImage class]]) 
    {        
        return NO;
    }
    if ([touch.view isKindOfClass:[UILabel class]]) 
    {
        return NO;
    }
    if ([touch.view isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

//方法类型：自定义方法
//编   写：
//方法功能：响应暂停操作
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTapsRequired == 1)       //单指单击
    {
        [self playOrPause];
    }
    else if(sender.numberOfTapsRequired == 2)   //单指双击
    {
        NSLog(@"单指双击");
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：响应上一曲操作
-(void)skipToPreviousItem
{
    [self destroyStreamer];
    if ([GlobalMusicPlayRow sharedSingleton].musicPlayRow > 0) 
    {
        [GlobalMusicPlayRow sharedSingleton].musicPlayRow = [GlobalMusicPlayRow sharedSingleton].musicPlayRow - 1;
        [self playQQMusic:[GlobalMusicPlayRow sharedSingleton].musicPlayRow];
        if ( showTips) 
        {
            [SVProgressHUD showImage:[UIImage imageNamed:@"OnA.png"] status:@"上一曲"];
            showTips = NO;
        }
    }
    else
    {
        [GlobalMusicPlayRow sharedSingleton].musicPlayRow = 0;
        [self playQQMusic:[GlobalMusicPlayRow sharedSingleton].musicPlayRow];
        [SVProgressHUD showImage:[UIImage imageNamed:@"Pause.png"] status:@"已经是第一曲啦"];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：响应下一曲操作
-(void)skipToNextItem
{
    [self destroyStreamer];
    if ([GlobalMusicPlayRow sharedSingleton].musicPlayRow < 99) 
    {
        [GlobalMusicPlayRow sharedSingleton].musicPlayRow = [GlobalMusicPlayRow sharedSingleton].musicPlayRow + 1;
        [self playQQMusic:[GlobalMusicPlayRow sharedSingleton].musicPlayRow];
        if (showTips) 
        {
            [SVProgressHUD showImage:[UIImage imageNamed:@"NextA.png"] status:@"下一曲"];
            showTips = NO;
            
        }
    }
    else
    {
        [GlobalMusicPlayRow sharedSingleton].musicPlayRow = 0;
        [self playQQMusic:[GlobalMusicPlayRow sharedSingleton].musicPlayRow];
        [SVProgressHUD showImage:[UIImage imageNamed:@"Pause.png"] status:@"已经是最后一曲啦,下面将为你播放第一曲."];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：响应暂停或播放功能
-(void)playOrPause
{
    if ([GlobalMusicPlayRow sharedSingleton].streamer)
    {
        if ([[GlobalMusicPlayRow sharedSingleton].streamer isPlaying]) 
        {
            [SVProgressHUD showImage:[UIImage imageNamed:@"Pause.png"] status:@"暂停"];
            [[GlobalMusicPlayRow sharedSingleton].streamer pause];
            isPlayOrPause = NO;
        }
        else if ([[GlobalMusicPlayRow sharedSingleton].streamer isPaused]) 
        {
            [SVProgressHUD showImage:[UIImage imageNamed:@"Player.png"] status:@"播放"];
            QQMusicSongSingleInfo *qqMusicinfo = [[GlobalMusicPlayRow sharedSingleton].musicTableViewArray objectAtIndex:[GlobalMusicPlayRow sharedSingleton].musicPlayRow];
            musicUrl = qqMusicinfo.mSongUrl;
            if (musicUrl) 
            {
                [self createStreamer];
                [[GlobalMusicPlayRow sharedSingleton].streamer start];
            }
            isPlayOrPause = YES;
        }
    }
}

#pragma mark - Player
//方法类型：自定义方法
//编   写：
//方法功能：播放音乐(首次进入，未选择播放曲目或选择曲目和播放曲目相同)MusicIcon.jpg

//if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"])
//{
//    NSString *musicLyrics = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"];
//    if ([musicLyrics isEqualToString:@"YES"]) 
//    {
//        [self startLrc:qqMusicinfo.mSongLrcUrl];
//    }
//}
//else 
//{
//    [self startLrc:qqMusicinfo.mSongLrcUrl];            
//}
-(void)playQQMusic:(NSInteger) musicRow
{
    [self destroyStreamer];
    QQMusicSongSingleInfo *qqMusicinfo = [[GlobalMusicPlayRow sharedSingleton].musicTableViewArray objectAtIndex:musicRow];
    musicUrl = qqMusicinfo.mSongUrl;
    if (musicUrl) {
        lSongName.text = qqMusicinfo.mSongName;
        lSingerName.text = qqMusicinfo.mSingerName;
        lAlbumName.text = qqMusicinfo.mAlbumName;
        [self createStreamer];
        [[GlobalMusicPlayRow sharedSingleton].streamer start];
        imageURLString = qqMusicinfo.mAlbumLink;
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"])
        {
            NSString *musicLyrics = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"];
            if ([musicLyrics isEqualToString:@"YES"]) 
            {
                [self startLrc:qqMusicinfo.mSongLrcUrl];
            }
        }
        else 
        {
            [self startLrc:qqMusicinfo.mSongLrcUrl];            
        }
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicImage"])
    {
        NSString *musicImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicImage"];
        if ([musicImage isEqualToString:@"YES"]) 
        {
            [self startDownload];
        }
    }
    else 
    {
        [self startDownload];
        
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：进入播放器,初始化界面(非首次进入)
-(void)loadedAgain
{
    QQMusicSongSingleInfo *qqMusicinfo = [[GlobalMusicPlayRow sharedSingleton].musicTableViewArray objectAtIndex:[GlobalMusicPlayRow sharedSingleton].musicPlayRow];
    musicUrl = qqMusicinfo.mSongUrl;
    if (musicUrl) {
        progressUpdateTimer = [NSTimer
                               scheduledTimerWithTimeInterval:0.1
                               target:self
                               selector:@selector(updateProgress:)
                               userInfo:nil
                               repeats:YES];
        lSongName.text = qqMusicinfo.mSongName;
        lSingerName.text = qqMusicinfo.mSingerName;
        lAlbumName.text = qqMusicinfo.mAlbumName;
        imageURLString = qqMusicinfo.mAlbumLink;
//        [self startLrc:qqMusicinfo.mSongLrcUrl];
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"])
        {
            NSString *musicLyrics = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"];
            if ([musicLyrics isEqualToString:@"YES"]) 
            {
                [self startLrc:qqMusicinfo.mSongLrcUrl];
            }
        }
        else 
        {
            [self startLrc:qqMusicinfo.mSongLrcUrl];            
        }

    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicImage"])
    {
        NSString *musicImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicImage"];
        if ([musicImage isEqualToString:@"YES"]) 
        {
            [self startDownload];
        }
    }
    else 
    {
        [self startDownload];
        
    }
    
}

//方法类型：自定义方法
//编   写：
//方法功能：拖动进度条，改变当前播放时间
- (IBAction)sliderMoved:(UISlider *)aSlider
{
	if ([GlobalMusicPlayRow sharedSingleton].streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * [GlobalMusicPlayRow sharedSingleton].streamer.duration;
		[[GlobalMusicPlayRow sharedSingleton].streamer seekToTime:newSeekTime];
	}
}

//方法类型：自定义方法
//编   写：
//方法功能：创建播放对象，启动通知
#pragma mark - AudioStreamer
- (void)createStreamer
{
	if ([GlobalMusicPlayRow sharedSingleton].streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
                                                         (CFStringRef)musicUrl,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)autorelease];
    
	NSURL *url = [NSURL URLWithString:escapedValue];
    
	[GlobalMusicPlayRow sharedSingleton].streamer = [[AudioStreamer alloc] initWithURL:url];
	progressUpdateTimer = [NSTimer
                           scheduledTimerWithTimeInterval:0.1
                           target:self
                           selector:@selector(updateProgress:)
                           userInfo:nil
                           repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(playbackStateChanged:)
                                                name:ASStatusChangedNotification
                                              object:[GlobalMusicPlayRow sharedSingleton].streamer];
    musicUrl = nil;
}

//方法类型：自定义方法
//编   写：
//方法功能：释放播放器资源
- (void)destroyStreamer
{
    [GlobalMusicPlayRow sharedSingleton]._lrc = nil;
    [GlobalMusicPlayRow sharedSingleton].musicLrcArray = nil;
    self.selectedLabel.text = @"";
    self.lrcLabel.text =@"";
	if ([GlobalMusicPlayRow sharedSingleton].streamer)
	{
		[[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:ASStatusChangedNotification
                                                     object:[GlobalMusicPlayRow sharedSingleton].streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[[GlobalMusicPlayRow sharedSingleton].streamer stop];
        [GlobalMusicPlayRow sharedSingleton].playStatus = NO;
		[[GlobalMusicPlayRow sharedSingleton].streamer release];
		[GlobalMusicPlayRow sharedSingleton].streamer = nil;
	}
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
//		[self spinButton];
	}
}


//方法类型：自定义方法
//编   写：
//方法功能：判断播放器播放状态，并进行处理
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([[GlobalMusicPlayRow sharedSingleton].streamer isWaiting])
	{
//        NSLog(@"isWaiting");
	}
	else if ([[GlobalMusicPlayRow sharedSingleton].streamer isPlaying])
	{
        [GlobalMusicPlayRow sharedSingleton].playStatus = YES;
	}
	else if ([[GlobalMusicPlayRow sharedSingleton].streamer isIdle] && isPlayOrPause)
	{ 
        musicUrl = nil;
        [pmusicPlayTime setProgress:0];
        iMusicPlaySchedule.text = [NSString stringWithFormat:@"0:00"];
        iMusicPlaySurplus.text = [NSString stringWithFormat:@"-0:00"];
        lSongName.text = @"";
        lSingerName.text = @"";
        lAlbumName.text = @"";
        [GlobalMusicPlayRow sharedSingleton]._lrc = nil;
        [GlobalMusicPlayRow sharedSingleton].musicLrcArray = nil;
        self.selectedLabel.text = nil;
        self.lrcLabel.text = nil;
        index = 0;
        [self skipToNextItem];
	}
    else 
    {
//        NSLog(@"暂停");
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：计算并设置播放器播放时间，设置进度条进度
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if ([GlobalMusicPlayRow sharedSingleton].streamer.bitRate != 0.0)
	{
		double progress = [GlobalMusicPlayRow sharedSingleton].streamer.progress;
		double duration = [GlobalMusicPlayRow sharedSingleton].streamer.duration;
		if (duration > 0)
		{
            iMusicPlaySchedule.text = [self timeStringWithNumber:(int)progress] ;
            iMusicPlaySurplus.text = [NSString stringWithFormat:@"-%@",[self timeStringWithNumber:(int)duration
                                                                        - (int)progress]];
            [pmusicPlayTime endEditing:YES];
            [pmusicPlayTime setProgress:progress / duration];
            if (!isLyrics) {
                [self totalTimeInterval:duration currentTimeInterval:progress];
            }
		}
		else
		{
            [pmusicPlayTime endEditing:NO];
		}
	}
	else
	{
        iMusicPlaySchedule.text = [NSString stringWithFormat:@"0:00"];
        iMusicPlaySurplus.text = [NSString stringWithFormat:@"-0:00"];
	}
}

//方法类型：自定义方法
//编   写：
//方法功能：播放时间换算成时间格式
-(NSString*)timeStringWithNumber:(float)theTime{
    NSString *minuteS=[NSString string];
    
    int minute=(theTime) / 60;
    if(theTime < 60){
        minuteS=[NSString stringWithString:@"00"];
    }else if(minute < 10){
        minuteS=[NSString stringWithFormat:@"0%i",(minute)];
    }else{
        minuteS=[NSString stringWithFormat:@"%i",(minute)];
    }
    
    NSString *playTimeS=[NSString string];
    if(theTime - 60 * minute < 10){
        playTimeS=[NSString stringWithFormat:@"%@:0%0.0f",minuteS,theTime-60*minute];
    }else{
        playTimeS=[NSString stringWithFormat:@"%@:%0.0f",minuteS,theTime-60*minute];
    }
    return playTimeS;
}


//方法类型：自定义方法
//编   写：
//方法功能：启动专辑下载
- (void)startDownload
{
    self.activeDownload = [NSMutableData data];    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:imageURLString]]delegate:self];
    
    self.imageConnection = conn;    
    [conn release];
}

//方法类型：自定义方法
//编   写：
//方法功能：取消专辑下载
- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection =nil;
    self.activeDownload =nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
//方法类型：系统方法
//编   写：
//方法功能：每次成功请求到数据后将调下此方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //把每次得到的数据依次放到数组中，这里还可以自己做一些进度条相关的效果
    [self.activeDownload appendData:data];
}

//方法类型：系统方法
//编   写：
//方法功能：下载错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeDownload =nil;
    self.imageConnection =nil;
    ialbumLarge.image = [UIImage imageNamed:@"MusicIcon.jpg"];
    [ialbumSmall setImage:[[ialbumLarge image] reflectionWithAlpha:0.8]];
}

//方法类型：系统方法
//编   写：
//方法功能：专辑下载成功
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    if (image) {
        ialbumLarge.image = image;
    }
    else 
    {
//        ialbumLarge.image = [UIImage imageNamed:@"MusicIcon.jpg"];
    }
    [ialbumSmall setImage:[[ialbumLarge image] reflectionWithAlpha:0.8]];
    [image release];
    self.activeDownload =nil;
    self.imageConnection =nil;
}


//方法类型：自定义方法
//编   写：
//方法功能：设置歌词获取URL，启动下载
#pragma mark - Lrc
-(void)startLrc:(NSString *)songUrl
{
    [GlobalMusicPlayRow sharedSingleton]._lrc = nil;
    [GlobalMusicPlayRow sharedSingleton].musicLrcArray = nil;
    SongLrcDownload *songlrcDownload = [[SongLrcDownload alloc]init];
    songlrcDownload.delegate=self;
    [songlrcDownload startDownloadWithURLString:songUrl];
    [songlrcDownload release];
}

//方法类型：自定义方法
//编   写：
//方法功能：歌词回调，排列并呈现歌词
-(void)QQMusicSongLrcdownloadFinishedWithResult:(NSString*)result
{
//    NSLog(@"回调了。。。。");;
    if ([result isEqualToString:@"歌词暂无"]) 
    {
        self.backScrollView.alpha = 0;
        self.ialbumLarge.alpha = 1;
//        self.lrcLabel.text = result;
        self.selectedLabel.text = result;
        isLyrics = NO;
        return;
    }
    else
    {
        isLyrics = NO;
        self.lrcLabel.text = @"";
        self.selectedLabel.text =@"";
        if (self.backScrollView.alpha == 1) 
        {
            self.ialbumLarge.alpha = 0.3;
            self.backScrollView.alpha = 1;
            
        }
    }    
    [GlobalMusicPlayRow sharedSingleton]._lrc = [JSLrcParser lrcValue:result];
    NSMutableString *s = [NSMutableString string];
    for (id key in [self lrcKeys]) 
    {
        [s appendString:[[GlobalMusicPlayRow sharedSingleton]._lrc.lyric objectForKey:key]];
        [s appendString:@"\n"];
    }
    CGSize size = [s sizeWithFont:self.lrcLabel.font
                constrainedToSize:(CGSize){self.lrcLabel.frame.size.width, NSIntegerMax}
                    lineBreakMode:self.lrcLabel.lineBreakMode];
    self.backScrollView.contentSize = (CGSize){size.width, size.height+120};
    UIEdgeInsets insets = (UIEdgeInsets){160, 0, 160, 0};
    self.backScrollView.scrollIndicatorInsets = insets;
    CGRect rect = (CGRect){{insets.left, insets.top}, {320, size.height}};
    self.lrcLabel.frame = rect;
    self.lrcLabel.text = s;
    [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];//自动滚动值
    [self.lrcLabel addSubview:self.selectedLabel];
    self.selectedLabel.frame = (CGRect){{0, 0}, {320, lrcLabel.font.lineHeight}};
    index = 0;
}


//方法类型：自定义方法
//编   写：
//方法功能：管理歌词动态
- (void)totalTimeInterval:(NSTimeInterval)total currentTimeInterval:(NSTimeInterval)timeInterval 
{
    if ([[GlobalMusicPlayRow sharedSingleton].musicLrcArray count] > index) 
    {
        if ([[[GlobalMusicPlayRow sharedSingleton].musicLrcArray objectAtIndex:index] doubleValue] <= timeInterval) {
            [self refreshView];
        }
    }
}


//方法类型：自定义方法
//编   写：
//方法功能：
- (void)playbackQueueStopped:(NSString *)fileName interruption:(NSObject *)reason 
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：歌词效果控制
#pragma mark -
- (void)refreshView 
{
    id key = [[GlobalMusicPlayRow sharedSingleton].musicLrcArray objectAtIndex:index];
    CGPoint point = self.backScrollView.contentOffset;
    NSString __autoreleasing *s = [[GlobalMusicPlayRow sharedSingleton]._lrc.lyric objectForKey:key];
    CGSize size = [s sizeWithFont:self.lrcLabel.font
                constrainedToSize:(CGSize){self.lrcLabel.frame.size.width, NSIntegerMax}
                    lineBreakMode:self.lrcLabel.lineBreakMode];
    self.selectedLabel.text = nil;
    __block int i = index;
    double duration = 0.0;
    if (index < [[GlobalMusicPlayRow sharedSingleton].musicLrcArray count]-1) {
        duration = [[[GlobalMusicPlayRow sharedSingleton].musicLrcArray objectAtIndex:++index] doubleValue] - [key doubleValue];
    }
    [self.backScrollView setContentOffset:(CGPoint){0, point.y+size.height} animated:YES];  //自动滚动值
    self.selectedLabel.text = s;
    __block CGRect r = self.selectedLabel.frame;
    self.selectedLabel.frame = (CGRect){{(320-size.width)/2, i*self.selectedLabel.font.lineHeight}, {0, r.size.height}};
    if (duration > 0.00001) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.selectedLabel.frame = (CGRect){{(320-size.width)/2, i*self.selectedLabel.font.lineHeight}, {size.width, r.size.height}};
                         }];
    } else {
        self.selectedLabel.frame = (CGRect){{(320-size.width)/2, i*self.selectedLabel.font.lineHeight}, {size.width, r.size.height}};
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：歌词键值处理
- (NSMutableArray *)lrcKeys 
{
    if ([GlobalMusicPlayRow sharedSingleton].musicLrcArray == nil) {
        [GlobalMusicPlayRow sharedSingleton].musicLrcArray = [NSMutableArray array];
    }
    if ([[GlobalMusicPlayRow sharedSingleton].musicLrcArray count]<1) {
        NSArray __autoreleasing *ks = [[[GlobalMusicPlayRow sharedSingleton]._lrc.lyric allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 floatValue] > [obj2 floatValue];
        }];
        if (ks) 
        {
            [[GlobalMusicPlayRow sharedSingleton].musicLrcArray addObjectsFromArray:ks];
        }
    }
    return [GlobalMusicPlayRow sharedSingleton].musicLrcArray;
}

//方法类型：自定义方法
//编   写：
//方法功能：检查网络状况
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

@end
