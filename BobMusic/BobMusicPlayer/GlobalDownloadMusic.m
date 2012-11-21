//
//  GlobalDownloadMusic.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlobalDownloadMusic.h"

@implementation GlobalDownloadMusic
@synthesize avaPlayer;
@synthesize selectedIndex;
@synthesize playIndex;

static NSTimer *ptimer;
static float durations;
static float periods;
static float splaycurrentTimes;

+ (void) gplayTime:(float)mduration time:(float)time
{
    durations = mduration;
    periods = time;
    if(ptimer)
    {
        [ptimer invalidate];
        ptimer = nil;
        splaycurrentTimes = 0;
    }
    ptimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerDidFires:) userInfo:nil repeats:YES];
}

+ (void) timerDidFires:(NSTimer *)theTimer
{
//    if(splaycurrentTimes >= 1.2)
//    {
//        splaycurrentTimes = 0.0;
//        [ptimer invalidate];
//        ptimer = nil;
//    }
//    else
//    {
        splaycurrentTimes += periods/durations;
//    }
    
    NSLog(@"splaycurrentTime = %f",splaycurrentTimes);
}

- (float) getcurrentTime
{
    return splaycurrentTimes;
}


- (void) timePause
{
    [ptimer invalidate];
    ptimer = nil;
}
+ (GlobalDownloadMusic *)sharedSingleton  
{
    static GlobalDownloadMusic *sharedSingleton;  
    @synchronized(self)  
    {  
        if (!sharedSingleton)
        {
            sharedSingleton = [[GlobalDownloadMusic alloc] init];
        }
        return sharedSingleton;  
    }
}

@end
