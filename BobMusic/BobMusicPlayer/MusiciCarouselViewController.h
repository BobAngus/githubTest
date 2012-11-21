//
//  MusiciCarouselViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "IPodMusicPlayerManager.h"
#import <CoreMotion/CoreMotion.h>

//NSMutableArray *musicByAlbum;
@interface MusiciCarouselViewController : UIViewController<iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,UIAccelerometerDelegate>{//AVAudioPlayerDelegate
    IPodMusicPlayerManager      *musicPlayerManager;    //音乐播放器
//    AVAudioPlayer		*avaPlayer;
    NSTimer				*updateTimer;

    BOOL				interrupted;
//    BOOL                playerAvAOrIpod;
}
@property (nonatomic,retain)  IPodMusicPlayerManager      *musicPlayerManager;
@property (retain,nonatomic)  NSString                    *musicListName;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (retain, nonatomic) IBOutlet UILabel *lalbumTitle;
@property (retain, nonatomic) IBOutlet UILabel *lselectalbumTitle;

@property (nonatomic,assign) BOOL wrap;

@property (retain, nonatomic) IBOutlet UILabel *duration;
@property (retain, nonatomic) IBOutlet UILabel *totaltime;
@property (retain, nonatomic) IBOutlet UISlider *sliderPlay;
- (IBAction)hearts:(id)sender;


//@property (nonatomic, retain) AVAudioPlayer *avaPlayer;
//- (MusiciCarouselViewController *)initWithSoundFiles:(NSMutableArray *)songs atPath:(NSString *)path andSelectedIndex:(int)index;
@property (nonatomic, retain) NSTimer *updateTimer;
@property (nonatomic, assign) BOOL interrupted;

//@property (nonatomic, assign) BOOL playerAvAOrIpod;
@end
