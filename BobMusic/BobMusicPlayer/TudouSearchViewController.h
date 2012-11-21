//
//  TudouSearchViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TudouHotMVGetter.h"


struct tableViewPagesArray{
    NSMutableArray *tableViewArray;
    int nowPageAt;
    int pagesCount;
};
@interface TudouSearchViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,HotMVGetterDelegate>{
    struct tableViewPagesArray searchResult;
    BOOL displaySearch;
    UISearchBar *searchBar;
}
@property (retain, nonatomic) IBOutlet UISearchBar *tudouSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tuDouTableView;
@end
