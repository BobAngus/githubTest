//
//  TudouListViewController.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"               //指示器
#import "TudouHotMVGetter.h"

struct tableViewPagesArray{
    NSMutableArray *tableViewArray;
    int nowPageAt;
    int pagesCount;
};

//UITableView
@interface TudouListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,HotMVGetterDelegate>{
    struct tableViewPagesArray hotMVResult;
//    struct tableViewPagesArray searchResult;
    BOOL firstLoaded;                   //第一次加载
    BOOL gettingMore;                   //加载更多
}
@property(assign,nonatomic)BOOL firstLoaded;
@property (strong, nonatomic) IBOutlet UITableView *tuDouTableView;
@end
