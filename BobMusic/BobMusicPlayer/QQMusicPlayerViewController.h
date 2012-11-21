//
//  QQMusicPlayerViewController.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Reflection.h"
#import "SongSingleListViewController.h"
#import "NewSongListViewController.h"
#import "ASIDownloadCache.h"
#import "SongLrcDownload.h"
#import "ASIHTTPRequest.h"


@interface QQMusicPlayerViewController : UIViewController<UIGestureRecognizerDelegate,NSURLConnectionDelegate,QQMusicSongLrcDownloaderDelegate,ASIHTTPRequestDelegate>
{
    NSTimer *progressUpdateTimer;
    NewSongListViewController *mnewSongListViewController;
    
    NSString *imageURLString;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    
}

@property (nonatomic, retain) NewSongListViewController *mnewSongListViewController;
@property (retain, nonatomic) IBOutlet UIImageView *ialbumLarge;
@property (retain, nonatomic) IBOutlet UIImageView *ialbumSmall;
@property (retain, nonatomic) IBOutlet UIProgressView *pmusicPlayTime;
@property (retain, nonatomic) IBOutlet UILabel *iMusicPlaySchedule;
@property (retain, nonatomic) IBOutlet UILabel *iMusicPlaySurplus;
@property (retain, nonatomic) IBOutlet UILabel *lSongName;
@property (retain, nonatomic) IBOutlet UILabel *lSingerName;
@property (retain, nonatomic) IBOutlet UILabel *lAlbumName;

@property (retain, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (retain, nonatomic) IBOutlet UILabel *selectedLabel;
@property (retain, nonatomic) IBOutlet UILabel *lrcLabel;

//@property (retain,nonatomic) NSMutableArray *_lrcKeys;

@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;


- (IBAction)sliderMoved:(UISlider *)aSlider;
- (void)startDownload;
- (void)cancelDownload;

@end