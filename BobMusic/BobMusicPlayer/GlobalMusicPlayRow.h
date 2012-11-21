//
//  GlobalMusicPlayRow.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"
#import "JSLrcParser.h"

@interface GlobalMusicPlayRow : NSObject
{
    NSString *qqMusicHitList;
    
    AudioStreamer *streamer;
    NSInteger musicPlayRow;
    NSInteger nNewmusicPlayRow;
    NSMutableArray *musicTableViewArray;
    BOOL playStatus;
}
+ (GlobalMusicPlayRow *)sharedSingleton;

@property (nonatomic,retain) NSString *qqMusicHitList;
@property (nonatomic,retain) AudioStreamer *streamer;
@property (nonatomic,assign) BOOL playStatus;
@property (nonatomic,assign) NSInteger musicPlayRow;
@property (nonatomic,assign) NSInteger nNewmusicPlayRow;
@property (nonatomic,retain) NSMutableArray *musicTableViewArray;

@property (nonatomic,retain) NSMutableArray *musicLrcArray;
@property (nonatomic,retain) JSLrc __strong *_lrc;
@end