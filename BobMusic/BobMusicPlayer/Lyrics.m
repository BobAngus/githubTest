//
//  Lyrics.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Lyrics.h"

@implementation Lyrics
@synthesize textLyrics;

- (void)viewDidUnload {
    [self setTextLyrics:nil];
    [super viewDidUnload];
}
@end
