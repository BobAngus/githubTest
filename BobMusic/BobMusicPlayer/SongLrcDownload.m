//
//  SongLrcDownload.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongLrcDownload.h"

@implementation SongLrcDownload

@synthesize songLrcDownload,songLrcConnection;
@synthesize delegate;

//方法类型：系统方法
//编   写：
//方法功能：初始化方法
-(id)init{
    if(self=[super init]){
        //
    }
    return self;
}

//方法类型：系统方法
//编   写：
//方法功能：设置下载url
-(void)startDownloadWithURLString:(NSString *)urlString
{
    if(self.songLrcConnection == nil){
        songLrcDownload = [NSMutableData data];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
        self.songLrcConnection = connection;
        if(songLrcConnection == nil)
        {
            return;
        }
    }
}

//方法类型：系统方法
//编   写：
//方法功能：通过response的响应，判断是否连接存在
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

//方法类型：系统方法
//编   写：
//方法功能：通过data获得请求后，返回的数据，数据类型NSData
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.songLrcDownload appendData:data];
}

//方法类型：系统方法
//编   写：
//方法功能：返回的错误信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.songLrcDownload=nil;
    self.songLrcConnection=nil;
}

//方法类型：系统方法
//编   写：
//方法功能：数据请求完毕，这个时候，用法是多线程的时候，通过这个通知，关部子线程
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *songLrcTemp = [[NSString alloc] initWithData:songLrcDownload encoding:gbkEncoding];
    if (songLrcTemp) {
        NSRange temprange1 = [songLrcTemp rangeOfString:@"[CDATA["];
        if (temprange1.length != 0) 
        {
            NSString *jsonTemp1 = [songLrcTemp substringFromIndex:temprange1.location + temprange1.length];
            NSRange temprange2 = [jsonTemp1 rangeOfString:@"]]"];
            NSString *jsonTemp2 = [jsonTemp1 substringToIndex:temprange2.location ];
            
            
            
            NSLog(@"歌词:%@",jsonTemp2);
            
            NSRange isGarbledTemp = [jsonTemp2 rangeOfString:@"&#"];
            if(self.delegate)
            {
                if (isGarbledTemp.length != 0) {
                    [delegate QQMusicSongLrcdownloadFinishedWithResult:[[NSString alloc]initWithString:@"歌词暂无"]];
                }
                else {
                    [delegate QQMusicSongLrcdownloadFinishedWithResult:[[NSString alloc]initWithString:jsonTemp2]];
                }
                
            }
        }
        else 
        {
            if(self.delegate)
            {
                [delegate QQMusicSongLrcdownloadFinishedWithResult:[[NSString alloc]initWithString:@"歌词暂无"]];
            }
        }
        self.songLrcDownload=nil;
        self.songLrcConnection=nil;
    }
}

@end
