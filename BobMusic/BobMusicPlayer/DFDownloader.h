//
//  DFDownloader.h
//  MusicPlayer
//
//  Created by Bill on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//下载
#import <Foundation/Foundation.h>

@protocol DFDownloaderDelegate <NSObject>
-(void)downloadFinishedWithResult:(NSString*)result Key:(NSString*)theKey;
@end

@interface DFDownloader : NSObject<NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSURLConnection *downloadConnection;
    NSString *key;
    
    NSStringEncoding usingEncoding;
    
    id<DFDownloaderDelegate> delegate;
}

@property(retain,nonatomic)NSMutableData *receivedData;         //接收到的数据
@property(retain,nonatomic)NSURLConnection *downloadConnection; //下载连接
@property(retain,nonatomic)NSString *key;                       //土豆应用程序key
@property(retain,nonatomic)id<DFDownloaderDelegate> delegate;   //委托

-(id)init;
-(void)startDownloadWithURLString:(NSString *)urlString Key:(NSString*)theKey Encoding:(NSStringEncoding)encoding;
-(void)cancelDownload;

@end
