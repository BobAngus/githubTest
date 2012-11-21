//
//  GlobalDownloadMusic.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h> 
@interface GlobalDownloadMusic : NSObject 
{
    NSUInteger			selectedIndex;
    NSUInteger			playIndex;
    AVAudioPlayer		*avaPlayer;
}
+ (GlobalDownloadMusic *)sharedSingleton;
+ (void) gplayTime:(float)mduration time:(float)time;
- (float) getcurrentTime;
- (void) timePause;

@property (nonatomic, retain) AVAudioPlayer *avaPlayer;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) NSUInteger playIndex;
//UISlider* mySlider = [ [ UISlider alloc ] initWithFrame:CGRectMake(20.0,10.0,200.0,
@end
