//
//  MusicDownloadCell.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "CERoundProgressView.h"
#import "CEPlayer.h"

@interface MusicDownloadCell : UITableViewCell
{
    FileModel *fileInfo;
}
@property(nonatomic,retain)FileModel *fileInfo;
@property (weak, nonatomic) IBOutlet UILabel *mRow;
@property (weak, nonatomic) IBOutlet UILabel *mSongName;
@property (weak, nonatomic) IBOutlet UIProgressView *mProgress;
@property (weak, nonatomic) IBOutlet UILabel *mSize;
@property (weak, nonatomic) IBOutlet UILabel *mCurrentSize;
@property (weak, nonatomic) IBOutlet UILabel *mAlbumName;
@property (weak, nonatomic) IBOutlet UIImageView *mImage;

@property (weak, nonatomic) IBOutlet UILabel *mFileRoute;
@property(nonatomic,retain)ASIHTTPRequest *request;//该文件发起的请求


@property (retain, nonatomic) CEPlayer *player;

@property (retain, nonatomic) IBOutlet CERoundProgressView *progressView;
@property (retain, nonatomic) IBOutlet UIButton *playPauseButton;

-(IBAction)operateTask:(id)sender;//操作（暂停、继续）正在下载的文件
@end
