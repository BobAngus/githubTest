//
//  AppDelegate.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "CommonHelper.h"
#import "DownloadDelegate.h"
#import "FileModel.h"
#import <AVFoundation/AVAudioPlayer.h>

@class OpeningViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,UIApplicationDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OpeningViewController *openingViewController; //解说View
    
@property(nonatomic,retain)NSMutableArray *finishedlist;        //已下载完成的文件列表（文件对象）
@property(nonatomic,retain)NSMutableArray *downinglist;         //正在下载的文件列表(ASIHttpRequest对象)
@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;
@property(nonatomic,retain)AVAudioPlayer *buttonSound;          //按钮声音
@property(nonatomic,retain)AVAudioPlayer *downloadCompleteSound;//下载完成的声音
@property(nonatomic)BOOL isFistLoadSound;                       //是否第一次加载声音，静音
@property(nonatomic,retain)NSString *musicFileSize;
-(void)loadTempfiles;       //将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
-(void)loadFinishedfiles;   //将本地已经下载完成的文件加载到已下载列表里
-(void)playButtonSound;     //播放按钮按下时的声音
-(void)playDownloadSound;   //播放下载完成时的声音

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;//点击下载，进行一次新的队列请求、是否接着开始下载
@end
