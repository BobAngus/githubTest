//
//  MusicDownloadViewController.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadDelegate.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "MusicDownloadCell.h"
#import "FileModel.h"
#import "MDAudioFile.h"


#import "CERoundProgressView.h"
#import "CEPlayer.h"

@interface MusicDownloadViewController : UIViewController<UITableViewDataSource,DownloadDelegate,AVAudioPlayerDelegate,CEPlayerDelegate>
{
    IBOutlet UITableView *musicDownloadingTable;
    IBOutlet  UITableView *musicFinishedTable;
    NSMutableArray *downingList;
    NSMutableArray *finishedList;
    
//    AVAudioPlayer		*avaPlayer;
    
    NSMutableArray		*soundFiles;
	NSString			*soundFilesPath;
	NSUInteger			selectedIndex;
}
@property (strong, nonatomic) IBOutlet UITableView *musicDownloadingTable;
@property(nonatomic,retain)IBOutlet UITableView *musicFinishedTable;
@property(nonatomic,retain)NSMutableArray *downingList;
@property(nonatomic,retain)NSMutableArray *finishedList;
- (IBAction)downloading:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *downloadingTitle;

//@property (nonatomic, retain) AVAudioPlayer *avaPlayer;

@property (nonatomic, retain) NSMutableArray *soundFiles;
@property (nonatomic, copy) NSString *soundFilesPath;

@end
