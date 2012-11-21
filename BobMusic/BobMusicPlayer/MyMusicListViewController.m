//
//  MyMusicListViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyMusicListViewController.h"
#import "iPodPlayerViewController.h"

@interface MyMusicListViewController ()

@end

@implementation MyMusicListViewController
@synthesize musicListName;

NSIndexPath *choiceRow;

//方法类型：系统方法
//编   写：
//方法功能：设置viewFrame
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
    }
    return self;
}

//方法类型：系统方法
//编   写：
//方法功能：初始化TableView显示数据
- (void)viewDidLoad
{
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [super viewDidLoad];
    MyMusicListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    
    MyMusicListTableView.delegate=self;
    MyMusicListTableView.dataSource=self;
    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueSea.jpg"]];
    downingImg.alpha=0.3f;
    MyMusicListTableView.backgroundView=downingImg;
    myMusictableViewItems = [[NSMutableArray alloc]initWithObjects:@"默认列表",@"下载音乐",nil];//@"我最爱听",@"最近播放"
    
    [self.view addSubview:MyMusicListTableView];
    if (musicListName == @"zjgd")
    {
        self.navigationItem.title = @"自建歌单";
    }
}

//方法类型：系统方法
//编   写：
//方法功能：资源释放
- (void)viewDidUnload
{
    [super viewDidUnload];
}

//方法类型：系统方法
//编   写：
//方法功能：手机朝向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
//方法类型：系统方法
//编   写：
//方法功能：返回组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：每组行数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myMusictableViewItems count];
}

//方法类型：系统方法
//编   写：
//方法功能：呈现tableView数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myMusicListItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setText:[myMusictableViewItems objectAtIndex:[indexPath row]]];
    return cell;
}


//方法类型：系统方法
//编   写：
//方法功能：通过返回一个Boolean类型的值来通知表视图某一行能否修改
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//方法类型：系统方法
//编   写：
//方法功能：是否执行移动操作的
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Table view delegate
//方法类型：系统方法
//编   写：
//方法功能：用户点击选择的行，条状到相应界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    choiceRow = indexPath;
    if (indexPath.row == 0) 
    {
        [self performSegueWithIdentifier:@"musicListDataSegue" sender:self];
    }
    else if (indexPath.row == 1) 
    {
        [self performSegueWithIdentifier:@"musicDownloadSegue" sender:self];
    }
    else if (indexPath.row == 2) 
    {
       
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//方法类型：系统方法 
//编   写：
//方法功能：跳转之前设置数据 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if (choiceRow) 
    {
        iPodPlayerViewController *mrlb = (iPodPlayerViewController *)segue.destinationViewController;
        if (choiceRow.row == 0) { 
            mrlb.musicListName = @"mrlb";
        } else if (choiceRow.row == 1) {
            
        } else if (choiceRow.row == 2) {
            
        }
    }
}

@end
