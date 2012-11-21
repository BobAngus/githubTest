//
//  MusiciCarouselViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


#import "MusiciCarouselViewController.h"
#import "GlobalMusicList.h"

#import "MDAudioFile.h"

#define kUpdateInterval               (1.0f/10.0f)

#define SCROLL_SPEED 1 //items per second, can be negative or fractional
#define ITEM_SPACING 200

@interface MusiciCarouselViewController ()

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, retain) UINavigationItem *navItem;

@property (nonatomic, assign) NSTimer *scrollTimer;
@property (nonatomic, assign) NSTimeInterval lastTime;

@end


@implementation MusiciCarouselViewController
@synthesize sliderPlay;
@synthesize musicPlayerManager;
@synthesize musicListName;

@synthesize navItem;
@synthesize carousel;
@synthesize wrap;

@synthesize lalbumTitle;
@synthesize lselectalbumTitle;
@synthesize duration;
@synthesize totaltime;

@synthesize images = _images;
@synthesize items;

@synthesize scrollTimer;
@synthesize lastTime;

//@synthesize avaPlayer;
@synthesize updateTimer;
@synthesize interrupted;
//@synthesize playerAvAOrIpod;

NSTimer *paylTotalTimer;

//方法类型：系统方法
//编   写：
//方法功能：进入初始化数据

- (void)viewDidLoad
{
    carousel.delegate = self;
    carousel.dataSource = self; 
//    carousel.type = iCarouselTypeRotary;
    [self sfStyle];
    self.navigationItem.title = @"CoverFlow";
    self.musicListName = @"iopdcf";
//    if (playerAvAOrIpod == NO) 
//    {
        if (!musicPlayerManager) 
        {
            musicPlayerManager = [[IPodMusicPlayerManager alloc]initWithPlayerType:1 LoadSong:nil];
            musicPlayerManager.StorageMusicName = self.musicListName;
            [self performSelector:@selector(albumQuery)];
            [self performSelector:@selector(registerForMediaPlayerNotifications)];
            [self handle_NowPlayingItemChanged];
            [self handle_PlaybackStateChanged];
        }
//    }
//    else
//    {
//        NSLog(@"AVA");
//    }
    
    
    UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate = self;
    accel.updateInterval = kUpdateInterval;
    
    [super viewDidLoad];
}

//- (void)awakeFromNib
//{
//    self.items = [NSMutableArray array];
//    for (int i = 0; i < [musicPlayerManager.mediaCollection count]; i++)
//    {
//        [items addObject:[NSNumber numberWithInt:i]];
//    }
//}

#pragma mark -
#pragma mark View lifecycle
//方法类型：系统方法
//编   写：
//方法功能：在IB中创建但在xocdde中被实例化时被调用的
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        wrap = YES;
    }
    
    return self;
}

//方法类型：自定义方法
//编   写：
//方法功能：初始化播放曲目
-(void)albumQuery
{
//    if (playerAvAOrIpod == NO) 
//    {
        if (![GlobalMusicList sharedSingleton].GNSMusicListName) 
        {
            [GlobalMusicList sharedSingleton].GNSMusicListName = @"mrlb";
        }
        if([[NSUserDefaults standardUserDefaults]objectForKey:[GlobalMusicList sharedSingleton].GNSMusicListName])
        {
            [GlobalMusicList sharedSingleton].GmediaItemCList = nil;
            [musicPlayerManager reload:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:[GlobalMusicList sharedSingleton].GNSMusicListName]]];
            [GlobalMusicList sharedSingleton].GmediaItemCList = musicPlayerManager.mediaCollection;
        }        
//    }
//    else 
//    {
//        [GlobalMusicList sharedSingleton].GNSMusicListName = @"";
//        [GlobalMusicList sharedSingleton].GmediaItemCList = nil;
//    }
    	[carousel reloadData];
}

//方法类型：系统方法
//编   写：
//方法功能：内存警报时，释放数据
- (void)viewDidUnload
{
    self.sliderPlay = nil;
    musicPlayerManager = nil;
    musicListName = nil;
    lalbumTitle = nil;
    lselectalbumTitle = nil;
    duration = nil;
    totaltime = nil;
    [self setLalbumTitle:nil];
    [self setLselectalbumTitle:nil];
    self.carousel = nil;
    self.navItem = nil;
    [scrollTimer invalidate];
    [paylTotalTimer invalidate];
    
    [super viewDidUnload];
}

//方法类型：系统方法
//编   写：
//方法功能：程序退出，释放数据
- (void)dealloc
{
    [sliderPlay release];
    [musicPlayerManager release];
    [musicListName release];
    [carousel release];
    [lalbumTitle release];
    [lselectalbumTitle release];
    [duration release];
    [totaltime release];
    [scrollTimer release];
    [paylTotalTimer release];
    [carousel release];
    [navItem release];
    [super dealloc];
}

//方法类型：自定义方法
//编   写：
//方法功能：iCarousel呈现样式
-(void)sfStyle
{
//    [[[UIAlertView alloc]initWithTitle:@"" message:@"Style" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CoverFlow"])
    {
        NSString *sTyle;
        sTyle = [[NSUserDefaults standardUserDefaults]objectForKey:@"CoverFlow"];
        
        for (UIView *view in carousel.visibleItemViews)
        {
            view.alpha = 1.0;
        }
        
        [UIView beginAnimations:nil context:nil];
        
        if ([sTyle isEqualToString:@"iCarouselTypeLinear"]) 
        {
            carousel.type = iCarouselTypeLinear;
        }
        else if([sTyle isEqualToString:@"iCarouselTypeRotary"])
        {
            carousel.type = iCarouselTypeRotary;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeInvertedRotary"])
        {
            carousel.type = iCarouselTypeInvertedRotary;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeCylinder"])
        {
            carousel.type = iCarouselTypeCylinder;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeInvertedCylinder"])
        {
            carousel.type = iCarouselTypeInvertedCylinder;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeWheel"])
        {
            carousel.type = iCarouselTypeWheel;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeInvertedWheel"])
        {
            carousel.type = iCarouselTypeInvertedWheel;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeCoverFlow"])
        {
            carousel.type = iCarouselTypeCoverFlow;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeCoverFlow2"])
        {
            carousel.type = iCarouselTypeCoverFlow2;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeTimeMachine"])
        {
            carousel.type = iCarouselTypeTimeMachine;
        } 
        else if([sTyle isEqualToString:@"iCarouselTypeInvertedTimeMachine"])
        {
            carousel.type = iCarouselTypeInvertedTimeMachine;
        }
        else 
        {
            carousel.type = iCarouselTypeCoverFlow;
        }
        [UIView commitAnimations];
    }
    else 
    {
        carousel.type = iCarouselTypeCoverFlow;
    }
}

//方法类型：系统方法
//编   写：
//方法功能：手机朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//#pragma mark -

//方法类型：自定义方法
//编   写：
//方法功能：动态设置iCarousel变化
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    
    [UIView beginAnimations:nil context:nil];
    carousel.type = buttonIndex;
    [UIView commitAnimations];
}

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel选择效果
- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel宽度
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

#pragma mark -
#pragma mark iCarousel methods

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel呈现项目数量
- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel是否允许无限滚动
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel呈现项目数量
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
//    if (playerAvAOrIpod == NO) 
//    {
        return [[GlobalMusicList sharedSingleton].GmediaItemCList count];
//    }
//    else 
//    {
//        return [[GlobalMusicList sharedSingleton].soundFiles count];
//    }
}

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel退出、进入效果
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionSpacing:
            return value * 1.1;
        default:
            return value;
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：呈现iCarousel旋转项目
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *button = (UIButton *)view;
    NSString *albumTitle;
	if (button == nil)
	{
//        if (playerAvAOrIpod == NO) 
//        {
            MPMediaItemArtwork *artWork = [[[[GlobalMusicList sharedSingleton].GmediaItemCList items]objectAtIndex:index]valueForProperty:MPMediaItemPropertyArtwork];
            albumTitle  = [[[[GlobalMusicList sharedSingleton].GmediaItemCList items]objectAtIndex:index]valueForProperty:MPMediaItemPropertyAlbumTitle];
            
            UIImage *artworkImage = [artWork imageWithSize:CGSizeMake(220, 220)];
            UIImage *image;
            if(artworkImage){
                image = artworkImage;
            }else{
                image = [UIImage imageNamed:@"no_album.png"];
            }
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0f, 0.0f, 220, 220);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.titleLabel.font = [button.titleLabel.font fontWithSize:12];
            [button addTarget:self action:@selector(buttonTapped:)forControlEvents:UIControlEventTouchUpInside];
//        }
//        else 
//        {
//            UIImage *image = [UIImage imageNamed:@"no_album.png"];
//            button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(0.0f, 0.0f, 220, 220);
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button setBackgroundImage:image forState:UIControlStateNormal];
//            button.titleLabel.font = [button.titleLabel.font fontWithSize:12];
//            [button addTarget:self action:@selector(buttonTappedAva:)forControlEvents:UIControlEventTouchUpInside];
//        }
	}
	return button;
}

#pragma mark -
#pragma mark Button tap event

-(void)buttonTappedAva:(UIButton *)sender
{
    NSInteger index = [carousel indexOfItemViewOrSubview:sender]; 
    CGFloat indexOfNowItem = (CGFloat)[musicPlayerManager.musicPlayer indexOfNowPlayingItem];

    if (index != indexOfNowItem) 
    {
    
    }
    else 
    {
        
    }
    
}

//方法类型：自定义方法
//编   写：
//方法功能：点击iCarousel旋转项目，对音乐播放状态进行处理
- (void)buttonTapped:(UIButton *)sender
{
    NSInteger index = [carousel indexOfItemViewOrSubview:sender]; 
    CGFloat indexOfNowItem = (CGFloat)[musicPlayerManager.musicPlayer indexOfNowPlayingItem];

    if (index != indexOfNowItem) 
    {
        [musicPlayerManager.musicPlayer setNowPlayingItem:[[[GlobalMusicList sharedSingleton].GmediaItemCList items]objectAtIndex:index]];
        [musicPlayerManager play];
    }
    else 
    {
        if (musicPlayerManager.musicPlayer.playbackState == MPMoviePlaybackStatePlaying) {
            [musicPlayerManager pause];
        }else if (musicPlayerManager.musicPlayer.playbackState == MPMoviePlaybackStatePaused) {
            [musicPlayerManager play];
        }
    }

}

//方法类型：自定义方法
//编   写：
//方法功能：转盘滚动动画将开始，将调用此方法
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousels
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：转盘滚动结束滚动时开始记时，是否倒退到正在播放的项目
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousels
{
    NSString *lalbumTitleUnderOn = self.lselectalbumTitle.text;
    NSString *lalbumTitleUnder = lalbumTitle.text;
    if ([lalbumTitleUnderOn isEqual: lalbumTitleUnder]) {
        [self performSelector:@selector(lableHide) withObject:nil afterDelay:2.8];
    }else {
        self.lselectalbumTitle.alpha = 1.0;
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：旋转的当前项目指数，用于显示当前歌曲信息
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousels{
    NSInteger index = carousel.currentItemIndex;
    NSString *albumArtist  = [[[[GlobalMusicList sharedSingleton].GmediaItemCList items]objectAtIndex:index]valueForProperty:MPMediaItemPropertyArtist];
    NSString *albumTitle  = [[[[GlobalMusicList sharedSingleton].GmediaItemCList items]objectAtIndex:index]valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumInfo = [NSString stringWithFormat:@"%@ - %@",albumTitle,albumArtist];
    self.lselectalbumTitle.text = albumInfo;
}

//方法类型：自定义方法
//编   写：
//方法功能：显示的歌曲信息为当前歌曲，将隐藏显示
-(void)lableHide
{
    self.lselectalbumTitle.alpha = 0;    
}

//方法类型：自定义方法
//编   写：
//方法功能：iCarousel开始拖动
- (void)carouselWillBeginDragging:(iCarousel *)carousels
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：iCarousel拖动结束时开始记时
- (void)carouselDidEndDragging:(iCarousel *)carousels willDecelerate:(BOOL)decelerate
{
    [carousel reloadData];
}


//方法类型：自定义方法
//编   写：
//方法功能：iCarousel拖动开始减速
- (void)carouselWillBeginDecelerating:(iCarousel *)carousels
{
    [carousels reloadData];
}

//方法类型：自定义方法
//编   写：
//方法功能：iCarousel拖动减速结束
- (void)carouselDidEndDecelerating:(iCarousel *)carousels
{
    [carousels reloadData];
}

#pragma mark -
#pragma mark Autoscroll

//方法类型：自定义方法
//编   写：
//方法功能：iCarousel自动拖动
- (void)scrollStep
{
    //计算时间差
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = lastTime - now;
    lastTime = now;
    
    //不自动滚动，当用户操纵旋转木马
    if (!carousel.dragging && !carousel.decelerating)
    {
        //滚动旋转木马
        carousel.scrollOffset += delta * (float)(SCROLL_SPEED);
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：返回当前播放项目
- (void)startCF
{    
    CGFloat indexOfNowItem = (CGFloat)[musicPlayerManager.musicPlayer indexOfNowPlayingItem];
//    if (indexOfNowItem) 
//    {
        carousel.scrollOffset = indexOfNowItem;
        [carousel reloadData];
//    }
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
							 object: musicPlayerManager.musicPlayer];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: musicPlayerManager.musicPlayer];
    [musicPlayerManager.musicPlayer beginGeneratingPlaybackNotifications];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放曲目改变时处理方法
- (void)handle_NowPlayingItemChanged
{
    MPMediaItem *currentItem = [musicPlayerManager.musicPlayer nowPlayingItem];//获得正在播放的项目
    if (currentItem) {
//      albumTitle = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle]; //获取专辑标题
        NSString *albumArtist  = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        NSString *albumTitle  = [currentItem valueForProperty:MPMediaItemPropertyTitle];
        NSString *albumInfo = [NSString stringWithFormat:@"%@ - %@",albumTitle,albumArtist];
        self.lalbumTitle.text = albumInfo;
    }
    
    CGFloat indexOfNowItem = (CGFloat)[musicPlayerManager.musicPlayer indexOfNowPlayingItem];
    if (indexOfNowItem) 
    {
        carousel.scrollOffset = indexOfNowItem;
        [carousel reloadData];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：播放曲目状态改变时处理方法
- (void)handle_PlaybackStateChanged
{
    MPMusicPlaybackState playbackState = [musicPlayerManager.musicPlayer playbackState];
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
		[musicPlayerManager.musicPlayer stop];
	}
}

//方法类型：自定义方法
//编   写：
//方法功能：判断播放曲目状态，改变当前播放时间显示
-(void)timerGoes:(NSTimer*)sender
{
    if(musicPlayerManager.musicPlayer.playbackState==MPMusicPlaybackStateStopped){
        [paylTotalTimer invalidate];
        paylTotalTimer=nil;        
    }else{
        float timeGoes=musicPlayerManager.musicPlayer.currentPlaybackTime;
        float readyTime=[[musicPlayerManager.musicPlayer.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration]floatValue];
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
//方法功能：更改当前进度，和播放时间显示
-(void)updateSliderWithValue:(float)value TimeGoes:(NSString *)goesTime readyTime:(NSString *)readyTime{
    sliderPlay.value=value;
    [duration setText:goesTime];
    [totaltime setText:readyTime];
}

//方法类型：自定义方法
//编   写：
//方法功能：时间换算
-(NSString*)timeStringWithNumber:(float)theTime{
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

//方法类型：自定义方法
//编   写：
//方法功能：处理用户摇动
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
//    NSString *str = [NSString stringWithFormat:@"x:%g\ty:%g\tz:%g",acceleration.x,acceleration.y,acceleration.z];
//    NSLog(@"%@",str);
    // 检测摇动, 1.5为轻摇，2.0为重摇
        if (fabsf(acceleration.x)>1.5||
            fabsf(acceleration.y)>1.5||
            fabsf(acceleration.z>1.5)) 
        {
            [self startCF];//摇动调用此方法
        }
}

//方法类型：自定义方法
//编   写：
//方法功能：添加到我最喜欢播放列表
- (IBAction)hearts:(id)sender 
{
    NSMutableArray *musicTemp;
    MPMediaItemCollection *mediaCollectionTemp; 
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"wzat"])
    {
        musicTemp = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"wzat"]];
        if([musicTemp count] > 0)
        {
           mediaCollectionTemp = [[MPMediaItemCollection alloc]initWithItems:(NSArray *)musicTemp];
            
            BOOL isADD = NO;
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[musicPlayerManager.mediaCollection items]];
            
            for(MPMediaItem *item in [mediaCollectionTemp items])
            {
                if([tempArray containsObject:item] == NO)//判断所选择音乐是否有添加过
                {
                    [tempArray addObject:item];
                    isADD = YES;
                }
            }
            
        }
    }
}
@end