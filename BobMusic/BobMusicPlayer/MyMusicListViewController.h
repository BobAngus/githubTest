//
//  MyMusicListViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMusicListViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *MyMusicListTableView;
    NSMutableArray *myMusictableViewItems;
}
@property(retain,nonatomic)NSString *musicListName;
@end
