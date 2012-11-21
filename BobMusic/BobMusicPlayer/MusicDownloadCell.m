//
//  MusicDownloadCell.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MusicDownloadCell.h"

@implementation MusicDownloadCell
@synthesize mRow;
@synthesize mSongName;
@synthesize mProgress;
@synthesize mSize;
@synthesize mCurrentSize;
@synthesize mAlbumName;
@synthesize mImage;
@synthesize mFileRoute;
@synthesize fileInfo;
@synthesize request;

@synthesize player;
@synthesize progressView;
@synthesize playPauseButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

//方法类型：自定义方法
//编   写：
//方法功能：暂停下载()
-(IBAction)operateTask:(id)sender
{
    AppDelegate *appDelegate = APPDELEGETE;
    UIButton *btnOperate=(UIButton *)sender;
    FileModel *downFile=((MusicDownloadCell *)[[[btnOperate superview] superview]superview]).fileInfo;
    if(downFile.isDownloading)//文件正在下载，点击之后暂停下载
    {
//        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_stop.png"] forState:UIControlStateNormal];
        downFile.isDownloading=NO;
        [request cancel];
        request=nil;
    }
    else
    {
//        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_go.png"] forState:UIControlStateNormal];
        downFile.isDownloading=YES;
        [appDelegate beginRequest:downFile isBeginDown:YES];
    }
    //暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttpreqst控制Cell
    UITableView *tableView=(UITableView *)[[[[btnOperate superview] superview] superview] superview];
    [tableView reloadData];
}
@end
