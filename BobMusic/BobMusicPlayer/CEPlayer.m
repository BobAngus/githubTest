//
//  CEPlayer.m
//  RoundProgress
//
//  Created by Renaud Pradenc on 04/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//

#import "CEPlayer.h"

//#define DURATION  10.0
//#define PERIOD    0.5

@interface CEPlayer ()
{
//    NSTimer *timer;
}

@end

@implementation CEPlayer
NSTimer *timer;
float duration;
float period;
- (void)dealloc
{
    [timer invalidate];
    
    [super dealloc];
}

- (void) play:(float)fduration Totaltime:(float)ftotaltime;
{
    duration = fduration;
    period = ftotaltime;
    if(timer)
    {
//        [timer invalidate];
//        return;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:period target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}
- (void) pause
{
    [timer invalidate];
    timer = nil;
}

- (void) timerDidFire:(NSTimer *)theTimer
{
    if(self.position >= 1.2)
    {
        self.position = 0.0;
//        [timer invalidate];
        timer = nil;
        [self.delegate playerDidStop:self];
    }
    else
    {
        self.position += period/duration;
        [self.delegate player:self didReachPosition:self.position];
    }
}

@synthesize position;  // 0..1

@synthesize delegate;

@end
