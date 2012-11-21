//
//  IPodMusicPlayerViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "DFLyricsMusicPlayer.h"
//#import "DFQianQianLyricsDownloader.h"

@interface IPodMusicPlayerManager : UIViewController
{
    MPMusicPlayerController     *musicPlayer;            //播放器
	MPMediaItemCollection       *mediaCollection;   //放置音乐的容器
}
@property   (nonatomic,retain) MPMusicPlayerController      *musicPlayer;
@property   (nonatomic,retain) MPMediaItemCollection        *mediaCollection;
@property   (nonatomic,retain) NSString                     *StorageMusicName;




//- (id)  initWithPlayerType:(NSInteger)PlayerType;
- (id)  initWithPlayerType:(NSInteger)PlayerType LoadSong:(NSArray *)SongList;
- (void)play;                       //播放
- (void)pause;                      //暫停
- (void)stop;                       //停止
- (void)prev;                       //下一首
- (void)next;                       //上一首
- (void)clearMusicPlayer;           //清空播放容器 
- (void)saveToData;                 //儲存
- (void)reload:(NSArray *)SongList; //重置播放容器
- (IBAction)playMode:(id)sender;
- (IBAction)managerPlayer:(id)sender;
- (IBAction)skipToPreviousItem:(id)sender;
- (IBAction)skipToNextItem:(id)sender;
- (IBAction)addGrouping:(id)sender;
//@property (weak, nonatomic) IBOutlet UIToolbar *imageplayMode;
@property (retain, nonatomic) IBOutlet UIButton *imageplayMode;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *imageAddGrouping;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *playOrPause;
@property (retain, nonatomic) IBOutlet UILabel *playOrPauseInfo;

@property (retain, nonatomic) IBOutlet UILabel *songTitle;
@property (retain, nonatomic) IBOutlet UILabel *singerName;
@property (retain, nonatomic) IBOutlet UILabel *duration;
@property (retain, nonatomic) IBOutlet UILabel *totaltime;
@property (retain, nonatomic) IBOutlet UISlider *sliderPlay;

@end
