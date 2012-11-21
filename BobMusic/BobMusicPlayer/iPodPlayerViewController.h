//
//  iPodPlayerViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMediaPickerController.h>
#import "SVProgressHUD.h"               //指示器
#import "IPodMusicPlayerManager.h"



@interface iPodPlayerViewController : UITableViewController<MPMediaPickerControllerDelegate>{
    IPodMusicPlayerManager      *musicPlayerManager;    //音乐播放器
}
@property   (nonatomic,retain)  IPodMusicPlayerManager      *musicPlayerManager;
@property   (retain,nonatomic)  NSString                    *musicListName;

@property   (weak, nonatomic)   IBOutlet     UITableView    *musicListView;

- (IBAction)refresh:(id)sender;
@end
