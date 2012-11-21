//
//  QQMusicDownloader.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QQMusicDownloaderDelegate <NSObject>
-(void)QQMusicdownloadFinishedWithResult:(NSString*)result;
@end

@interface QQMusicDownloader : NSObject<NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSURLConnection *downloadConnection; 
    NSStringEncoding usingEncoding;
    id<QQMusicDownloaderDelegate> delegate;
}

@property(retain,nonatomic)NSMutableData *receivedData;         //接收到的数据
@property(retain,nonatomic)NSURLConnection *downloadConnection; //下载连接
@property(retain,nonatomic)id<QQMusicDownloaderDelegate> delegate;   //委托

-(id)init;
-(void)startDownloadWithURLString:(NSString *)urlString;
-(void)cancelDownload;

@end
