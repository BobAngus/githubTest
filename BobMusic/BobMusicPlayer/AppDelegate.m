//
//  AppDelegate.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "OpeningViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@implementation AppDelegate
@synthesize window = _window;
@synthesize openingViewController = _openingViewController;

@synthesize downinglist=_downinglist;
@synthesize downloadDelegate=_downloadDelegate;
@synthesize finishedlist=_finishedList;
@synthesize buttonSound=_buttonSound;
@synthesize downloadCompleteSound=_downloadCompleteSound;
@synthesize isFistLoadSound=_isFirstLoadSound;
@synthesize musicFileSize;


//方法类型：系统方法
//编   写：
//方法功能：判断是否首次进入，如果首次进入则开启解说界面
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions 1");
    self.isFistLoadSound=NO;
    [self loadFinishedfiles];
    [self loadTempfiles];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) { 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"]; 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"]; 
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        OpeningViewController *appStartController = [[OpeningViewController alloc] init];
        self.window.rootViewController = appStartController;
    }else {
        UIStoryboard * storyboard = [ UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        self.window.rootViewController=controller;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//方法类型：系统方法
//编   写：
//方法功能：当按下Home键发生
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//方法类型：系统方法
//编   写：
//方法功能：方法释放\销毁数据时发生 作用如保存用户数据\关闭网络连接等
- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    [[MPMusicPlayerController iPodMusicPlayer]stop];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//方法类型：系统方法
//编   写：
//方法功能：重建applicationDidEnterBackground方法所释放和销毁的数据
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//方法类型：系统方法
//编   写：
//方法功能：程序切回前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//方法类型：系统方法
//编   写：
//方法功能：跳过暂停状态并终止应用程序执行
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//方法类型：自定义方法
//编   写：
//方法功能：播放音效
-(void)playButtonSound
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *result=[userDefaults objectForKey:@"isOpenAudio"];
    NSURL *url=[[[NSBundle mainBundle]resourceURL] URLByAppendingPathComponent:@"btnEffect.wav"];
    NSError *error;
    if(self.buttonSound==nil)
    {
        self.buttonSound=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    if([result isEqualToString:@"YES"]||result==nil)//播放声音
    {
        if(!self.isFistLoadSound)
        {
            self.buttonSound.volume=1.0f;
        }
    }
    else
    {
        self.buttonSound.volume=0.0f;
    }
    [self.buttonSound play];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放下载成功音效
-(void)playDownloadSound
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *result=[userDefaults objectForKey:@"isOpenAudio"];
    NSURL *url=[[[NSBundle mainBundle]resourceURL] URLByAppendingPathComponent:@"download-complete.wav"];
    NSError *error;
    if(self.downloadCompleteSound==nil)
    {
        self.downloadCompleteSound=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    if([result isEqualToString:@"YES"]||result==nil)//播放声音
    {
        if(!self.isFistLoadSound)
        {
            self.downloadCompleteSound.volume=1.0f;
        }
    }
    else
    {
        self.downloadCompleteSound.volume=0.0f;
    }
    [self.downloadCompleteSound play];
}


//方法类型：自定义方法
//编   写：
//方法功能：开始下载
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    NSLog(@"beginRequest 2");
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:[CommonHelper getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //文件开始下载时，把文件名、文件总大小、文件URL写入文件，上海滩.rtf中间用逗号隔开
    NSString *writeMsg=[fileInfo.fileName stringByAppendingFormat:@",%@,%@",fileInfo.fileSize,fileInfo.fileURL];
    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    NSString *name=[fileInfo.fileName substringToIndex:index];
    [writeMsg writeToFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    
    //按照获取的文件名获取临时文件的大小，即已下载的大小
    fileInfo.isFistReceived=YES;
    NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    
    //如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    for(ASIHTTPRequest *tempRequest in self.downinglist)
    {
        if([[NSString stringWithFormat:@"%@",tempRequest.url] isEqual:fileInfo.fileURL])
        {
            [self.downinglist removeObject:tempRequest];
            break;
        }
    }
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
    [request setTemporaryFileDownloadPath:[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    [request setDownloadProgressDelegate:self];
    //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    if(isBeginDown)
    {
        fileInfo.isDownloading=YES;
    }
    else
    {
        fileInfo.isDownloading=NO;
    }
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    if (isBeginDown) {
        [request startAsynchronous];
    }
    [self.downinglist addObject:request];
}

//方法类型：自定义方法
//编   写：
//方法功能：取消下载
-(void)cancelRequest:(ASIHTTPRequest *)request
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：资源临时存储处理
-(void)loadTempfiles
{
    NSLog(@"loadTempfiles 3");
    self.downinglist = [[NSMutableArray alloc] init];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTempFolderPath] error:&error];
    if(!error)
    {
//        NSLog(@"loadTempfiles Error %@",[error description]);
    }
    for(NSString *file in filelist)
    {
        if([file rangeOfString:@".rtf"].location<=100)//以.rtf结尾的文件是下载文件的配置文件，存在文件名称，文件总大小，文件下载URL
        {
            NSInteger index=[file rangeOfString:@"."].location;
            NSString *trueName=[file substringToIndex:index];
            
            //临时文件的配置文件的内容
            NSString *msg=[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",trueName]]] encoding:NSUTF8StringEncoding];
            
            //取得第一个逗号前的文件名
            index=[msg rangeOfString:@","].location;
            NSString *name=[msg substringToIndex:index];
            msg=[msg substringFromIndex:index+1];
            
            //取得第一个逗号和第二个逗间的文件总大小
            index=[msg rangeOfString:@","].location;
//            NSString *totalSize=[msg substringToIndex:index];
            msg=[msg substringFromIndex:index+1];
            
            //取得第二个逗号后的所有内容，即文件下载的URL
            NSString *url=msg;
            
            //按照获取的文件名获取临时文件的大小，即已下载的大小
            NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",name]]];
            NSInteger receivedDataLength=[fileData length];
            
            //实例化新的文件对象，添加到下载的全局列表，但不开始下载
            FileModel *tempFile=[[FileModel alloc] init];
            tempFile.fileName=name;
//            tempFile.fileSize=totalSize;
            if (musicFileSize) 
            {
                tempFile.fileSize = musicFileSize;
            }
            tempFile.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
            tempFile.fileURL=url;
            tempFile.isDownloading=NO;
            [self beginRequest:tempFile isBeginDown:NO];
        }
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：获取本地资源文件
-(void)loadFinishedfiles
{
    NSLog(@"loadFinishedfiles 4");
    self.finishedlist=[[NSMutableArray alloc] init];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTargetFloderPath] error:&error];
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSLog(@"filelist = %@",filelist);
    
    if(!error)
    {
//        NSLog(@"loadFinishedfiles %@",[error description]);
    }
    for(NSString *fileName in filelist)
    {
        if([fileName rangeOfString:@"."].location<100)              //出去Temp文件夹
        {
            NSString *path = [documentDir stringByAppendingPathComponent:fileName]; 
            NSString *lastComponent = [path lastPathComponent];  
            NSString *pathLessFilename = [path stringByDeletingLastPathComponent];  
            NSString *originalPath = [pathLessFilename stringByAppendingPathComponent: lastComponent]; 
            NSString *pathExtension = [[path pathExtension] lowercaseString]; 
            if ([pathExtension isEqualToString:@"mp3"])
            {
                FileModel *finishedFile=[[FileModel alloc] init];
                finishedFile.fileName=fileName;
                NSInteger length=[[fileManager contentsAtPath:[[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:fileName]] length];    //根据文件名获取文件的大小
                
                finishedFile.fileRoute = originalPath;
                finishedFile.fileSize=[CommonHelper getFileSizeString:[NSString stringWithFormat:@"%d",length]];          
                
                [self.finishedlist addObject:finishedFile];
                
            }
        }
    }
}

#pragma ASIHttpRequest回调委托
//方法类型：自定义方法
//编   写：
//方法功能：出错，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
}

//方法类型：自定义方法
//编   写：
//方法功能：收到回复，准备下载
-(void)requestStarted:(ASIHTTPRequest *)request
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：获取资源文件大小
-(void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
    NSLog(@"requestReceivedResponseHeaders 5");
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    fileInfo.fileSize = [CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
}

//方法类型：自定义方法
//编   写：
//方法功能：获取已下载资源大小
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSLog(@"didReceiveBytes 6");
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(!fileInfo.isFistReceived)
    {
        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:FileSize:)])
    {
        if (musicFileSize) 
        {
            [self.downloadDelegate updateCellProgress:request FileSize:musicFileSize];
        }
        else 
        {
            [self.downloadDelegate updateCellProgress:request FileSize:@"稍等"];
        }
        
    }
    fileInfo.isFistReceived=NO;
}

//方法类型：自定义方法
//编   写：
//方法功能：获取下载资源大小
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders 
{
    NSLog(@"didReceiveResponseHeaders 7");
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##.00M;"];    
    musicFileSize = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[responseHeaders valueForKey:@"Content-Length"] floatValue]/1024/1024]];
    if (musicFileSize) {
        FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
        fileInfo.fileSize = musicFileSize;
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
     NSLog(@"requestFinished 8");
//    [self playDownloadSound];         //播放音效果
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    NSString *name=[fileInfo.fileName substringToIndex:index];;
    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
    }
    if(!error)
    {
        NSLog(@"error %@",[error description]);
    }
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegate finishedDownload:request];
    }
}
@end
