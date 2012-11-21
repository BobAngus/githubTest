//
//  iPodMusicListViewController.m
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iPodMusicListViewController.h"
#import "MyMusicListViewController.h"

@interface iPodMusicListViewController ()

@end

@implementation iPodMusicListViewController

//方法类型：系统方法
//编   写：
//方法功能：
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
//方法功能：初始化UITableView
- (void)viewDidLoad
{
    iPodMusicListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    
    iPodMusicListTableView.delegate = self;
    iPodMusicListTableView.dataSource = self;
    iPodMusictableViewItems = [[NSMutableArray alloc]initWithObjects:@"iPod所有歌曲",@"自建歌单",nil];
    
    [self.view addSubview:iPodMusicListTableView];
    [super viewDidLoad];
}

//方法类型：系统方法
//编   写：
//方法功能：释放资源
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
//方法功能：tableView组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{ 
    // Return the number of sections.
    return 1;
}

//方法类型：系统方法
//编   写：
//方法功能：每组显示数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    // Return the number of rows in the section.
    return [iPodMusictableViewItems count];
}

//方法类型：系统方法
//编   写：
//方法功能：呈现数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"iPodMusicListItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setText:[iPodMusictableViewItems objectAtIndex:[indexPath row]]];
    return cell;
}


#pragma mark - Table view delegate

//方法类型：系统方法
//编   写：
//方法功能：用户点击选择的行，条状到相应界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        [self performSegueWithIdentifier:@"atewst" sender:self];
//        if([[NSUserDefaults standardUserDefaults]objectForKey:@"mrlb"])
//        {
            [self performSegueWithIdentifier:@"ICarouselSegue" sender:self];
//        }
//        else 
//        {
//            [[[UIAlertView alloc] initWithTitle:@"iPod-CoverFlow" 
//                                        message:@"默认列表没有歌曲,请先添加歌曲!" 
//                                       delegate:nil 
//                              cancelButtonTitle:@"ok" 
//                              otherButtonTitles:nil]show];
//        }
        
    }else if (indexPath.row == 1) 
    {
        [self performSegueWithIdentifier:@"iPodmusicListSegue" sender:self];
    }
    else if (indexPath.row == 2) 
    {
    }
    else if (indexPath.row == 3) 
    {
        
    }
}
//方法类型：系统方法
//编   写：
//方法功能：跳转之前设置数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"iPodmusicListSegue"]) { 
        MyMusicListViewController *zjgd = (MyMusicListViewController *)segue.destinationViewController;
        zjgd.musicListName = @"zjgd";
    } else if ([segue.identifier isEqualToString: @"musicListDataSegue"]) {
        
    }
}

@end
