//
//  SongSingleListViewController.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongSingleListViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *songSingleListTableView;
    NSMutableArray *songSingleListViewItems;
}
@end
