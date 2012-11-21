//
//  NewSongListViewController.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "QQMusicGetter.h"

#import "FileModel.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "CommonHelper.h"

struct tableViewArray{
    NSMutableArray __unsafe_unretained *tableViewArray;
};
@interface NewSongListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,QQMusicGetterDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate>
{
    struct tableViewArray QQMusicResult;
    NSInteger dowanloaderTableRow;
//    NSInteger playRow;         //接收到的数据
    FileModel *fileInfo;
    NSMutableArray *musicList;//用来存档音乐的列表
    BOOL isFinished;//是否二次加载文件大小和名字完成
}
@property(nonatomic,retain) NSString *qqMusicList;
- (IBAction)dowanloadMusic:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *qqMusicTableView;

@property(nonatomic,retain)FileModel *fileInfo;
@property(nonatomic,retain)NSMutableArray *musicList;
@property(nonatomic)BOOL isFinished;
@end
