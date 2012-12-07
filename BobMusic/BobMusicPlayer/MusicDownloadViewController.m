//
//  MusicDownloadViewController.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MusicDownloadViewController.h"
#import "GlobalDownloadMusic.h"
#import "GlobalMusicPlayRow.h"
@interface MusicDownloadViewController ()

@end

@implementation MusicDownloadViewController
@synthesize downloadingTitle;
@synthesize musicDownloadingTable;
@synthesize musicFinishedTable;
@synthesize downingList;
@synthesize finishedList;

//@synthesize avaPlayer;
@synthesize soundFiles;
@synthesize soundFilesPath;
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

//方法类型：系统方法
//编   写：
//方法功能：接到内存警告 可删除
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//方法类型：系统方法
//编   写：
//方法功能：加载本地下载音乐数据
-(void)viewWillAppear:(BOOL)aviewWillAppearnimated
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    AppDelegate *appDelegate=APPDELEGETE;
    appDelegate.downloadDelegate=self;
    self.downingList=appDelegate.downinglist;
    self.finishedList=appDelegate.finishedlist;
    [self.musicFinishedTable reloadData];
    [self.musicDownloadingTable reloadData];
    if ([GlobalMusicPlayRow sharedSingleton].streamer)
    {
        if ([[GlobalMusicPlayRow sharedSingleton].streamer isPlaying]) 
        {
            [[GlobalMusicPlayRow sharedSingleton].streamer pause];;
        }
    }
    
//    [self musicDataLoad];
//    fileArray = self.finishedList;
}

//方法类型：系统方法
//编   写：
//方法功能：视图即将可见时，开始接收远程控制事件
- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}


//方法类型：系统方法
//编   写：
//方法功能：视图被驳回时调用，覆盖或以其他方式隐藏时，结束远程控制事件
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [self becomeFirstResponder];
} 

//方法类型：系统方法
//编   写：
//方法功能：使becomeFirstResponder可返回YES,使其成为第一响应者
- (BOOL) canBecomeFirstResponder  
{
    return YES;  
}

//方法类型：系统方法
//编   写：
//方法功能：远程事件处理(播放器 播放、暂停、上、下一曲)
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([GlobalDownloadMusic sharedSingleton].avaPlayer.playing) 
                {
                    [[GlobalDownloadMusic sharedSingleton].avaPlayer pause];
                    [[GlobalDownloadMusic sharedSingleton] timePause];
                } 
                else  
                {
                    [[GlobalDownloadMusic sharedSingleton].avaPlayer play];
                    [GlobalDownloadMusic gplayTime:[GlobalDownloadMusic sharedSingleton].avaPlayer.duration time:1.0];
                    
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self musicPlay:[GlobalDownloadMusic sharedSingleton].playIndex - 2];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self musicPlay:[GlobalDownloadMusic sharedSingleton].playIndex];
                break;
                
            default:
                break;
        }
    }
}

//方法类型：系统方法
//编   写：
//方法功能：设置背景
- (void)viewDidLoad
{
     [super viewDidLoad];
    self.navigationItem.title = @"已下载的文件";
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    self.musicDownloadingTable.backgroundView=downingImg;
    UIImageView *finishedImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    finishedImg.alpha=0.3f;
    self.musicFinishedTable.backgroundView=finishedImg;
}

//方法类型：系统方法
//编   写：
//方法功能：资源释放
- (void)viewDidUnload
{
    self.musicFinishedTable=nil;
    self.musicDownloadingTable=nil;
    [self setDownloadingTitle:nil];
    [super viewDidUnload];
}

//方法类型：系统方法
//编   写：
//方法功能：手机朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//方法类型：系统方法
//编   写：
//方法功能：返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.musicDownloadingTable)
    {
        return [self.downingList count];
    }
    else
    {
        return [self.finishedList count];
    }
}

//方法类型：系统方法
//编   写：
//方法功能：设置RowHeight
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

//方法类型：系统方法
//编   写：
//方法功能：加载本地资源文件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.musicFinishedTable)//下载完成文件列表
    {
        static NSString *CellIdentifier = @"MusicDownloadCell"; //dequeueResableCellWithIdentifier
//        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
        MusicDownloadCell *cell=(MusicDownloadCell *)[self.musicDownloadingTable dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"MusicDownloadCell" owner:self options:nil];
            for(id obj in objlist)
            {
                if([obj isKindOfClass:[MusicDownloadCell class]])
                {
                    cell=(MusicDownloadCell *)obj;
                }
            }
            
        }
        FileModel *fileInfo=[self.finishedList objectAtIndex:indexPath.row];
        cell.mRow.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
        cell.progressView.alpha = 1;
        NSString *tempName = fileInfo.fileName;
        NSRange temprange = [tempName rangeOfString:@".mp3"];
        NSString *tempFileName = [tempName substringToIndex:temprange.location]; 
        cell.mSongName.text = tempFileName;
        cell.mSize.text = fileInfo.fileSize;
        cell.mProgress.alpha = 0;
        cell.playPauseButton.tag = indexPath.row ;// + 1
        [cell.playPauseButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];    
        cell.mFileRoute.text = fileInfo.fileRoute;
        cell.mFileRoute.tag = 1000 + indexPath.row;
        cell.mImage.image = [UIImage imageNamed:@"action_check.png"];
        cell.mAlbumName.text = fileInfo.fileAlbumName;
        cell.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        cell.progressView.startAngle = (3.0*M_PI)/2.0;
        if (([GlobalDownloadMusic sharedSingleton].playIndex - 1 == indexPath.row))//&& [GlobalDownloadMusic sharedSingleton].playIndex != 0
        {
            [cell.playPauseButton setImage:[UIImage imageNamed:@"Pauses"] forState:UIControlStateNormal];
            cell.player = [[CEPlayer alloc] init];
            cell.player.delegate = self;
            UIColor *tintColor = [UIColor blueColor];
            [[CERoundProgressView appearance] setTintColor:tintColor];
            cell.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
            cell.progressView.startAngle = (3.0*M_PI)/2.0;
            [cell.player play:[GlobalDownloadMusic sharedSingleton].avaPlayer.duration Totaltime:1.0]; 
            if ([GlobalDownloadMusic sharedSingleton].avaPlayer)
            {
                if ([[GlobalDownloadMusic sharedSingleton].avaPlayer isPlaying]) 
                {
                    if ([GlobalDownloadMusic sharedSingleton].avaPlayer.currentTime) 
                    {
                        cell.progressView.progress = [[GlobalDownloadMusic sharedSingleton] getcurrentTime];
                    }
                }
            }
            
            
        }
        
        return cell;
    }
    else if (tableView == self.musicDownloadingTable) 
    {
        static NSString *downCellIdentifier=@"downloadCell";
        MusicDownloadCell *cell=(MusicDownloadCell *)[self.musicFinishedTable dequeueReusableCellWithIdentifier:downCellIdentifier];
        if(cell==nil)
        {
            NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"MusicDownloadCell" owner:self options:nil];
            for(id obj in objlist)
            {
                if([obj isKindOfClass:[MusicDownloadCell class]])
                {
                    cell=(MusicDownloadCell *)obj;
                }
            }
        }
        ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
        FileModel *fileInfo=[theRequest.userInfo objectForKey:@"File"];
        cell.mSongName.text = fileInfo.fileName;
        cell.mSize.text = fileInfo.fileSize;
        cell.fileInfo = fileInfo;
        cell.mCurrentSize.text = [CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
        cell.mImage.image = [UIImage imageNamed:@"arrow_down.png"];
        cell.mAlbumName.text = @"";
        cell.progressView.alpha = 0;
        cell.mProgress.alpha = 1;
        [cell.mProgress setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
        if(fileInfo.isDownloading==YES)//文件正在下载 执行暂停操作
        {
//            [cell.operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_go.png"] forState:UIControlStateNormal];
        }
        else
        {
//            [cell.operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_stop.png"] forState:UIControlStateNormal];
        }
        return cell;
    }
    return nil;
}

//方法类型：系统方法
//编   写：
//方法功能：删除指定数据
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)//点击了删除按钮,注意删除了该视图列表的信息后，还要更新UI和APPDelegate里的列表
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        if(tableView.tag == 101)//正在下载的表格
        {
            ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
            if([theRequest isExecuting])
            {
                [theRequest cancel];
            }
            FileModel *fileInfo=(FileModel*)[theRequest.userInfo objectForKey:@"File"];
            NSString *path=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]];
            NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
            NSString *name=[fileInfo.fileName substringToIndex:index];
            NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]];
            [fileManager removeItemAtPath:path error:&error];
            [fileManager removeItemAtPath:configPath error:&error];
            if(!error)
            {
                NSLog(@"%@",[error description]);
            }
            [self.downingList removeObjectAtIndex:indexPath.row];
            [self.musicDownloadingTable reloadData];
        }
        else//已经完成下载的表格
        {
            FileModel *selectFile = [self.finishedList objectAtIndex:indexPath.row];
            NSString *path = [[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",selectFile.fileName]];
            [fileManager removeItemAtPath:path error:&error];
            if(!error)
            {
                NSLog(@"%@",[error description]);
            }
            [self.finishedList removeObject:selectFile];
            [self.musicFinishedTable reloadData];
//            [self musicDataLoad];
        }
    }   
}


#pragma mark - Table view delegate
//方法类型：自定义方法
//编   写：
//方法功能：
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];   
}

#pragma mark - DownloadDelegate
//方法类型：自定义方法
//编   写：
//方法功能：开始下载
-(void)startDownload:(ASIHTTPRequest *)request
{
    
}

//方法类型：自定义方法
//编   写：
//方法功能：下载中...
-(void)updateCellProgress:(ASIHTTPRequest *)request FileSize:(NSString*)musicFileSize
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

//方法类型：自定义方法
//编   写：
//方法功能：完成下载
-(void)finishedDownload:(ASIHTTPRequest *)request
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [self.downingList removeObject:request];
    [self.finishedList addObject:fileInfo];
    [self.musicDownloadingTable reloadData];
    [self.musicFinishedTable reloadData];
//    [self musicDataLoad];
}

//方法类型：自定义方法
//编   写：
//方法功能：根据下载进度,修改信息
-(void)updateCellOnMainThread:(FileModel *)fileInfo
{
    for(id obj in self.musicDownloadingTable.subviews)//?
    {
        if([obj isKindOfClass:[MusicDownloadCell class]])
        {
            MusicDownloadCell *cell=(MusicDownloadCell *)obj;
            NSLog(@"%@ - %@",cell.fileInfo.fileURL,fileInfo.fileURL);
            if(cell.fileInfo.fileURL == fileInfo.fileURL)
            {
                cell.mRow.alpha = 0;
                cell.mCurrentSize.alpha = 1;
                cell.mCurrentSize.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
                [cell.mProgress setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
            }
        }
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：点击判断当前view'并切换view
- (IBAction)downloading:(id)sender 
{
    if ([self.downloadingTitle.title isEqualToString:@"正在下载"]) 
    {
        self.downloadingTitle.title = @"下载完成";
        [self showDowning];
    }
    else
    {
        self.downloadingTitle.title = @"正在下载";
        [self showFinished];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：切换已下载视图
-(void)showFinished
{
    self.navigationItem.title = @"已下载的文件";
    [self startFlipAnimation:0];
}

//方法类型：自定义方法
//编   写：
//方法功能：切换正在下载视图
-(void)showDowning
{
    
    self.navigationItem.title = @"正在下载的文件";
    [self startFlipAnimation:1];
}

//方法类型：自定义方法
//编   写：
//方法功能：转场动画
-(void)startFlipAnimation:(NSInteger)type
{
    //    [APPDELEGETE playButtonSound];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    UIView *lastView=[self.view viewWithTag:103];
    
    if(type == 0)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lastView cache:YES];
    }
    
    UITableView *frontTableView=(UITableView *)[lastView viewWithTag:101];
    UITableView *backTableView=(UITableView *)[lastView viewWithTag:102];
    NSInteger frontIndex=[lastView.subviews indexOfObject:frontTableView];
    NSInteger backIndex=[lastView.subviews indexOfObject:backTableView];
    [lastView exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
    [UIView commitAnimations];
}

//方法类型：自定义方法
//编   写：
//方法功能：播放暂停项目
- (void)playAudio:(UIButton *)button
{
//    [[MPMusicPlayerController iPodMusicPlayer]stop];
    NSInteger index = button.tag;
    NSInteger selectIndex = [GlobalDownloadMusic sharedSingleton].selectedIndex;
    if (!selectIndex) 
    {
        selectIndex = 0;
    }
    if (selectIndex != index || selectIndex == 0) 
    {
        [self musicPlay:index];
    }
    else
    {
        if ([GlobalDownloadMusic sharedSingleton].avaPlayer.playing) 
        {
            [[GlobalDownloadMusic sharedSingleton].avaPlayer pause];
            [[GlobalDownloadMusic sharedSingleton] timePause];
            [button setImage:[UIImage imageNamed:@"Plays"] forState:UIControlStateNormal];
        } 
        else  
        {
            [[GlobalDownloadMusic sharedSingleton].avaPlayer play];
            [GlobalDownloadMusic gplayTime:[GlobalDownloadMusic sharedSingleton].avaPlayer.duration time:1.0];
            [button setImage:[UIImage imageNamed:@"Pauses"] forState:UIControlStateNormal]; 
        } 
    }    
}

//方法类型：自定义方法
//编   写：
//方法功能：播放
-(void)musicPlay:(NSInteger )palyItem
{
    NSError *error = nil;
    MusicDownloadCell *cell = (MusicDownloadCell *)[self.musicFinishedTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:palyItem inSection:0]];
    UILabel *lFileRout = (UILabel *)[cell viewWithTag:(1000+palyItem)];
    NSURL *mFileRoute = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",lFileRout.text]isDirectory:YES];
    NSRange temprange = [[NSString stringWithFormat:@"%@",mFileRoute] rangeOfString:@".mp3"];
    if (temprange.length == 0) 
    {
        NSString *mtempUrl = [self musicFind:[NSString stringWithFormat:@"%@.mp3",cell.mSongName.text]];
        mFileRoute = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",mtempUrl]isDirectory:YES];
    }
    [GlobalDownloadMusic sharedSingleton].avaPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mFileRoute error:&error];
    [[GlobalDownloadMusic sharedSingleton].avaPlayer setNumberOfLoops:0];
    [[GlobalDownloadMusic sharedSingleton].avaPlayer setDelegate:self];
    
    [[GlobalDownloadMusic sharedSingleton].avaPlayer play];
    [GlobalDownloadMusic gplayTime:[GlobalDownloadMusic sharedSingleton].avaPlayer.duration time:1.0];
    [GlobalDownloadMusic sharedSingleton].selectedIndex = palyItem;

    cell.player = [[CEPlayer alloc] init];
    [self resetIcon];
    cell.player.delegate = self;
    UIColor *tintColor = [UIColor blueColor];
    [[CERoundProgressView appearance] setTintColor:tintColor];
    cell.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    cell.progressView.startAngle = (3.0*M_PI)/2.0;
    [cell.player play:[GlobalDownloadMusic sharedSingleton].avaPlayer.duration Totaltime:1.0];
    [GlobalDownloadMusic sharedSingleton].playIndex = palyItem + 1;
    [self.musicFinishedTable reloadData];
}

//方法类型：自定义方法
//编   写：
//方法功能：回调。播放进度
- (void) player:(CEPlayer *)player didReachPosition:(float)position
{
    MusicDownloadCell *cell = (MusicDownloadCell *)[self.musicFinishedTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[GlobalDownloadMusic sharedSingleton].playIndex - 1 inSection:0]];
//    cell.progressView.progress = position;
    cell.progressView.progress = [[GlobalDownloadMusic sharedSingleton]getcurrentTime];  
}

//方法类型：自定义方法
//编   写：
//方法功能：停止
- (void) playerDidStop:(CEPlayer *)player
{
    MusicDownloadCell *cell = (MusicDownloadCell *)[self.musicFinishedTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[GlobalDownloadMusic sharedSingleton].playIndex - 1 inSection:0]];
    cell.playPauseButton.selected = NO;
    cell.progressView.progress = 0.0;
}

//方法类型：自定义方法
//编   写：
//方法功能：新下载音乐查找本地链接
- (NSString *)musicFind:(NSString *)musicName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];      
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; 
    NSError *error = nil;  
    NSArray *fileList = [[NSArray alloc] init]; 
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];  
    for (NSString *file in fileList) 
    {
        NSString *path = [documentDir stringByAppendingPathComponent:file]; 
        NSString *lastComponent = [path lastPathComponent];  
        NSString *pathLessFilename = [path stringByDeletingLastPathComponent];  
        NSString *originalPath = [pathLessFilename stringByAppendingPathComponent: lastComponent];         
        
        if ([lastComponent isEqualToString:musicName])
        {
            return originalPath;
        }
    }
    return @"";
}

//方法类型：自定义方法
//编   写：
//方法功能：重置播放图标
- (void)resetIcon
{
    MusicDownloadCell *cell;
    for (int i = 1; i < [self.finishedList count]; i++) 
    {
        cell = (MusicDownloadCell *)[self.musicFinishedTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIButton *buttonIoc = (UIButton *)[cell viewWithTag:i];
        [buttonIoc setImage:[UIImage imageNamed:@"Plays"] forState:UIControlStateNormal];
        cell.playPauseButton.selected = NO;
        cell.progressView.progress = 0.0;
//        [cell.player setDelegate:nil];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：播放结束播放下一曲
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{  
    NSLog(@"播放结束播放下一曲");
    [self musicPlay:[GlobalDownloadMusic sharedSingleton].playIndex];
}  

//方法类型：自定义方法
//编   写：
//方法功能：解码错误执行的动作
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error
{  
    
}  

//方法类型：自定义方法
//编   写：
//方法功能：处理中断
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player
{  
    
}  

//方法类型：自定义方法
//编   写：
//方法功能：处理中断结束
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player
{
    
} 

@end
