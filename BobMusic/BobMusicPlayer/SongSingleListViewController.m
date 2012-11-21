//
//  SongSingleListViewController.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongSingleListViewController.h"
#import "NewSongListViewController.h"
#import "GlobalMusicPlayRow.h"
@interface SongSingleListViewController ()

@end

@implementation SongSingleListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//方法类型：系统方法
//编   写：
//方法功能：初始化自定义view
- (void)viewDidLoad
{
    
    songSingleListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    
    songSingleListTableView.delegate=self;
    songSingleListTableView.dataSource=self;
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    songSingleListTableView.backgroundView=downingImg;
    songSingleListViewItems = [[NSMutableArray alloc]initWithObjects:@"QQ音乐 新歌榜",@"QQ音乐 总榜",nil];//@"下载音乐",
    
    [self.view addSubview:songSingleListTableView];
    [super viewDidLoad];
}

//方法类型：系统方法
//编   写：
//方法功能：系统内存警告时，释放资源
- (void)viewDidUnload
{
    [super viewDidUnload];
}


//方法类型：系统方法
//编   写：
//方法功能：手机支持的朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//方法类型：系统方法
//编   写：
//方法功能：组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：每组行数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [songSingleListViewItems count];
}

//方法类型：系统方法
//编   写：
//方法功能：显示分组内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setText:[songSingleListViewItems objectAtIndex:[indexPath row]]];
    
    return cell;
}

#pragma mark - Table view delegate
//方法类型：系统方法
//编   写：
//方法功能：判断用户选择的列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) 
    {
        [GlobalMusicPlayRow sharedSingleton].qqMusicHitList = @"newSong";
        [self performSegueWithIdentifier:@"QQMusicListSegue" sender:self];
    }
    else if (indexPath.row == 1) 
    {
        [GlobalMusicPlayRow sharedSingleton].qqMusicHitList = @"allSong";
        [self performSegueWithIdentifier:@"QQMusicListSegue" sender:self];
    }
    else if (indexPath.row == 2) 
    {
//        [self performSegueWithIdentifier:@"QQMusicListSegue" sender:self];
    }
}

//方法类型：系统方法
//编   写：
//方法功能：跳转之前数据设置
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
//    NewSongListViewController *mNewSongListViewController = [[NewSongListViewController alloc]init];
//    mNewSongListViewController.qqMusicList = qqMusicPlayList;
}

@end
