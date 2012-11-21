//
//  iPodMusicListViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPodMusicListViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *iPodMusicListTableView;
    NSMutableArray *iPodMusictableViewItems;
}


@end
