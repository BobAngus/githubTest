//
//  SongLrcDownload.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol QQMusicSongLrcDownloaderDelegate <NSObject>
-(void)QQMusicSongLrcdownloadFinishedWithResult:(NSString*)result;
@end

@interface SongLrcDownload : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *songLrcDownload;
    NSURLConnection *songLrcConnection;
    id<QQMusicSongLrcDownloaderDelegate> delegate;
}

@property (nonatomic,retain) NSMutableData *songLrcDownload;
@property (nonatomic,retain) NSURLConnection *songLrcConnection;
@property(retain,nonatomic)id<QQMusicSongLrcDownloaderDelegate> delegate;

-(id)init;
-(void)startDownloadWithURLString:(NSString *)urlString;
@end
