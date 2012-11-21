//
//  AlbumCover.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlbumCover.h"

@implementation AlbumCover
@synthesize artworkImage;
@synthesize LMusicLyrics;

- (void)viewDidUnload {
    [self setArtworkImage:nil];
    [self setLMusicLyrics:nil];
    [super viewDidUnload];
}
@end
