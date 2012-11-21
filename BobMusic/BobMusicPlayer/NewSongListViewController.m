//
//  NewSongListViewController.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewSongListViewController.h"
#import "QQMusicGetter.h"
#import "QQMusicSongSingleInfo.h"
#import "QQMusicPlayerViewController.h"
#import "GlobalMusicPlayRow.h"
#import "GlobalDownloadMusic.h"
#import "Reachability.h"
NSInteger playRow;
NSInteger selectRow;

@interface NewSongListViewController ()
@end

@implementation NewSongListViewController

@synthesize qqMusicList;
@synthesize qqMusicTableView;
@synthesize fileInfo;
@synthesize musicList;
@synthesize isFinished;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//方法类型：系统方法
//编   写：
//方法功能：设置navigationItem,调用加载网络资源方法
- (void)viewDidLoad
{
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    qqMusicTableView.backgroundView=downingImg;
    if ([GlobalMusicPlayRow sharedSingleton].qqMusicHitList) {
        if ([GlobalMusicPlayRow sharedSingleton].qqMusicHitList == @"newSong") 
        {
            self.navigationItem.title = @"QQ新歌榜";
        }
        else if ([GlobalMusicPlayRow sharedSingleton].qqMusicHitList == @"allSong")
        {
            self.navigationItem.title = @"QQ 总榜";
        }
        
    }
    [self loadQQMusicData];
    [super viewDidLoad];
}

//方法类型：系统方法
//编   写：
//方法功能：内存不足是释放资源
- (void)viewDidUnload
{

    [self setQqMusicTableView:nil];
    [super viewDidUnload];
}

//方法类型：自定义方法
//编   写：
//方法功能：加载网络资源
-(void)loadQQMusicData
{
    NSString *tempWifi = [self GetCurrntNet];
    if (![tempWifi isEqualToString:@"wifi"]) 
    {
        [SVProgressHUD showImage:[UIImage imageNamed:@"action_delete.png"] status:@"没有检查到Wifi信号"];
        return;
    }
    if(!QQMusicResult.tableViewArray){
        QQMusicResult.tableViewArray=[[NSMutableArray alloc]init];
    }
    QQMusicGetter *getter = [[[QQMusicGetter alloc]init]autorelease];
    getter.delegate = self;
    NSString *musicurlString;
//    if (qqMusicList) 
//    {
        if ([GlobalMusicPlayRow sharedSingleton].qqMusicHitList == @"newSong") 
        {
            musicurlString=[NSString stringWithFormat:@"http://music.qq.com/musicbox/shop/v3/data/hit/hit_newsong.js"];
        }
        else if ([GlobalMusicPlayRow sharedSingleton].qqMusicHitList == @"allSong")
        {
            musicurlString=[NSString stringWithFormat:@"http://music.qq.com/musicbox/shop/v3/data/hit/hit_all.js"];
        }
        
//    }
    [getter getQQMusicInfoData:musicurlString];
    [SVProgressHUD showWithStatus:@"榜单内容加载中..."];
//    [musicurlString release];
}
//方法类型：系统方法
//编   写：
//方法功能：设置加上任务栏显示
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//方法类型：系统方法
//编   写：
//方法功能：组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：每组行数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [QQMusicResult.tableViewArray count];
}


//方法类型：系统方法
//编   写：
//方法功能：行数据呈现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QQMusicIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    QQMusicSongSingleInfo *qqMusicinfo = [QQMusicResult.tableViewArray objectAtIndex:indexPath.row];
    
    UILabel *lRow = (UILabel *)[cell viewWithTag:1];
    lRow.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    
    UILabel *lSong = (UILabel *)[cell viewWithTag:2];
    lSong.text = qqMusicinfo.mSongName;
    
    UILabel *lSinger = (UILabel *)[cell viewWithTag:3];
    lSinger.text = qqMusicinfo.mSingerName;
    
    UILabel *lPlayTime = (UILabel *)[cell viewWithTag:4];
    float iPlayTime = [qqMusicinfo.mPlaytime floatValue] / 60;
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setPositiveFormat:@"##.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:iPlayTime]]; 
    
    lPlayTime.text = formattedNumberString;
    return cell;
}

#pragma mark - Table view delegate
//方法类型：系统方法
//编   写：
//方法功能：点击音乐，开始跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    playRow = indexPath.row;
    [self performSegueWithIdentifier:@"QQMusicPlaySegue" sender:self];
}

//方法类型：系统方法
//编   写：
//方法功能：跳转之前设置数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if (!playRow) 
    {
        playRow = 0;
    }    
    [GlobalMusicPlayRow sharedSingleton].nNewmusicPlayRow = playRow;    
    [GlobalMusicPlayRow sharedSingleton].musicTableViewArray = QQMusicResult.tableViewArray;
    playRow = 0;
}

#pragma mark - QQMusicdownload delegate
//方法类型：系统方法
//编   写：
//方法功能：获取音乐数据
-(void)QQMusicInformation:(struct QQMusicInformation)result
{
    for (QQMusicSongSingleInfo *musicInfo in result.QQMusicInfo) 
    {
        [QQMusicResult.tableViewArray addObject:musicInfo];
    }
    [self.tableView reloadData];
    [SVProgressHUD showSuccessWithStatus:@"加载完毕!"];

}

//方法类型：系统方法
//编   写：
//方法功能：用户点击下载图标,弹出选择UIActionSheet选择操作
- (IBAction)dowanloadMusic:(id)sender 
{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    selectRow = [path row];
    QQMusicSongSingleInfo *qqMusicinfo = [QQMusicResult.tableViewArray objectAtIndex:selectRow];
    self.fileInfo=[[FileModel alloc] init];
   
    self.fileInfo.fileReceivedSize=@"0";
    self.fileInfo.fileID=@"0";
    self.fileInfo.fileName= [NSString stringWithFormat:@"%@ - %@.mp3",qqMusicinfo.mSingerName,qqMusicinfo.mSongName];
    self.fileInfo.fileAlbumName = qqMusicinfo.mAlbumName;
    self.fileInfo.fileSize=@"未知";
    self.fileInfo.fileURL=qqMusicinfo.mSongUrl;
    self.fileInfo.isDownloading=NO;
    
    NSString *prompInfo = [NSString stringWithFormat:@"是否下载音乐:%@ - %@",qqMusicinfo.mSingerName,qqMusicinfo.mSongName];
    
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:prompInfo
                           delegate:self
                           cancelButtonTitle:@"取消下载"
                           destructiveButtonTitle:@"开始下载"
                           otherButtonTitles:nil, nil];
    [menu showInView:[UIApplication sharedApplication].keyWindow];
}

//方法类型：系统方法
//编   写：
//方法功能：ASIHTTPRequest请求失败信息
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败%@",[request error]);
}

//方法类型：系统方法
//编   写：
//方法功能：选择UIActionSheet项目，执行下载
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) 
    {
        if (selectRow) 
        {
            FileModel *selectFileInfo=self.fileInfo;
            //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
            NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:selectFileInfo.fileName];
            NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:selectFileInfo.fileName]stringByAppendingString:@".temp"];
            if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本首歌曲已下载,是否重新下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                [alert release];
                return;
            }
            //存在于临时文件夹里
            if([CommonHelper isExistFile:tempPath])
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本首歌曲已下载,是否重新下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                [alert release];
                return;
            }
            selectFileInfo.isDownloading=YES;
            //若不存在文件和临时文件，则是新的下载
            AppDelegate *appDelegate=APPDELEGETE;
            [appDelegate beginRequest:selectFileInfo isBeginDown:YES];
        }        
    }
    [actionSheet release];
}

//方法类型：系统方法
//编   写：
//方法功能：执行用户下载选择
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)//确定按钮
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        AppDelegate *appDelegate=APPDELEGETE;
        NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:self.fileInfo.fileName];
        NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:self.fileInfo.fileName]stringByAppendingString:@".temp"];
        if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
        {
            [fileManager removeItemAtPath:targetPath error:&error];
            if(!error)
            {
                NSLog(@"删除文件出错:%@",error);
            }
            for(FileModel *file in appDelegate.finishedlist)
            {
                if([file.fileName isEqualToString:self.fileInfo.fileName])
                {
                    [appDelegate.finishedlist removeObject:file];
                    break;
                }
            }
        }    
        //存在于临时文件夹里
        if([CommonHelper isExistFile:tempPath])
        {
            [fileManager removeItemAtPath:tempPath error:&error];
            if(!error)
            {
                NSLog(@"删除临时文件出错:%@",error);
            }
        }
        
        for(ASIHTTPRequest *request in appDelegate.downinglist)
        {
            FileModel *fileModel=[request.userInfo objectForKey:@"File"];
            if([fileModel.fileName isEqualToString:self.fileInfo.fileName])
            {
                [appDelegate.downinglist removeObject:request];
                break;
            }
        }
        self.fileInfo.isDownloading=YES;
        self.fileInfo.fileReceivedSize=[CommonHelper getFileSizeString:@"0"];
        [appDelegate beginRequest:self.fileInfo isBeginDown:YES];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：检查网络状况
-(NSString*)GetCurrntNet
{
    NSString* result = nil;
    Reachability *reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:// 没有网络连接
            result=nil;
            break;
        case ReachableViaWWAN:// 使用3G网络
            result=@"3g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            result=@"wifi";
            break;
    }
    return result;
}

@end
