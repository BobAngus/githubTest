//
//  MusicAppsetUp.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MusicAppsetUp.h"

@interface MusicAppsetUp ()

//@property (nonatomic, retain) UISwitch *airplaneModeSwitch;

@end
@implementation MusicAppsetUp
//@synthesize airplaneModeSwitch = _airplaneModeSwitch;


//- (id) init {
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if (!self) return nil;
//    
//	self.title = NSLocalizedString(@"设置", @"Settings");
//    
//	return self;
//}
@synthesize sMusicLyrics;
@synthesize sMusicImage;
@synthesize bcfValues;
@synthesize autoDownload;

//方法类型：系统方法
//编   写：
//方法功能：调用初始化方法
- (void) viewDidLoad 
{
    [self musicImage];
    [self musicLyrics];
    [self cfVlues];
    [self musicDownload];
	[super viewDidLoad];
}

//方法类型：自定义方法
//编   写：
//方法功能：是否自动下载专辑图片
- (void)musicImage
{
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicImage"])
    {
        NSString *musicImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicImage"];
        if ([musicImage isEqualToString:@"YES"]) 
        {
            self.sMusicImage.on = YES;
        }
        else 
        {
            self.sMusicImage.on = NO;            
        }
    }
    else 
    {
        self.sMusicImage.on = YES;
        
    }

}

//方法类型：自定义方法
//编   写：
//方法功能：设置是否自动下载音乐
- (void)musicDownload
{
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"autoDownload"])
    {
        NSString *musicDownload = [[NSUserDefaults standardUserDefaults]objectForKey:@"autoDownload"];
        if ([musicDownload isEqualToString:@"YES"]) 
        {
            self.autoDownload.on = YES;
        }
        else 
        {
            self.autoDownload.on = NO;            
        }
    }
    else 
    {
        self.autoDownload.on = YES;
        
    }
    
}
//方法类型：自定义方法
//编   写：
//方法功能：是否自动下载歌词
-(void)musicLyrics
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"])
    {
        NSString *musicLyrics = [[NSUserDefaults standardUserDefaults]objectForKey:@"musicLyrics"];
        if ([musicLyrics isEqualToString:@"YES"]) 
        {
            self.sMusicLyrics.on = YES;
        }
        else 
        {
            self.sMusicLyrics.on = NO;            
        }
    }
    else 
    {
        self.sMusicLyrics.on = YES;
        
    }

}

//方法类型：自定义方法
//编   写：
//方法功能：当前iCarousel设置值
- (void)cfVlues
{
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"CoverFlow"])
    {
        NSString *cfVlues = [[NSUserDefaults standardUserDefaults]objectForKey:@"CoverFlow"];
        
        if ([cfVlues isEqualToString:@"iCarouselTypeLinear"])
        {
            [bcfValues setTitle:@"直线" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeRotary"]) 
        {
            [bcfValues setTitle:@"圆圈" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeInvertedRotary"]) 
        {
            NSLog(@"cfVlues = %@",cfVlues);
            [bcfValues setTitle:@"圆圈(反向)" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeCylinder"]) 
        {
            [bcfValues setTitle:@"圆柱" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeInvertedCylinder"]) 
        {
            [bcfValues setTitle:@"圆柱(反向)" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeWheel"]) 
        {
            [bcfValues setTitle:@"车轮" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeInvertedWheel"]) 
        {
            [bcfValues setTitle:@"车轮(反向)" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeCoverFlow"]) 
        {
            [bcfValues setTitle:@"CoverFlow1" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeCoverFlow2"]) 
        {
            [bcfValues setTitle:@"CoverFlow2" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeTimeMachine"]) 
        {
            [bcfValues setTitle:@"顺时针" forState:UIControlStateNormal];
        }
        else if ([cfVlues isEqualToString:@"iCarouselTypeInvertedTimeMachine"]) 
        {
            [bcfValues setTitle:@"反时针" forState:UIControlStateNormal];
        }
    }
    else 
    {
        [bcfValues setTitle:@"CoverFlow1" forState:UIControlStateNormal];
    }
}

//方法类型：自定义方法
//编   写：
//方法功能：手机朝向
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//方法类型：自定义方法
//编   写：
//方法功能：设置是否自动下载歌词
- (IBAction)musicLyrics:(id)sender 
{
    BOOL lState;
    NSString *lMusicLrcState;
    lState = self.sMusicLyrics.isOn;
    
    if (lState) 
    {
        lMusicLrcState = [NSString stringWithFormat:@"YES"];
    }
    else
    {
        lMusicLrcState = [NSString stringWithFormat:@"NO"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:lMusicLrcState forKey:@"musicLyrics"];
	[[NSUserDefaults standardUserDefaults]synchronize];  
}

//方法类型：自定义方法
//编   写：
//方法功能：设置是否自动专辑图片
- (IBAction)musicImage:(id)sender 
{
    BOOL lState;
    NSString *lMusicImage;
    lState = self.sMusicImage.isOn;//获得开关状态
    if (lState) 
    {
        lMusicImage = [NSString stringWithFormat:@"YES"];
    }
    else
    {
        lMusicImage = [NSString stringWithFormat:@"NO"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:lMusicImage forKey:@"musicImage"];
	[[NSUserDefaults standardUserDefaults]synchronize]; 
}

//方法类型：自定义方法
//编   写：
//方法功能：弹出UIActionSheet，让用户选择iCarousel呈现样式
- (IBAction)cfStyle:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"选择播放器呈现类型"
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"直线",@"圆圈",@"圆圈(反向)",@"圆柱",
                           @"圆柱(反向)",@"车轮",@"车轮(反向)",@"CoverFlow1",@"CoverFlow2",@"顺时针",@"反时针", nil];
    [menu showInView:self.view];
}

//方法类型：自定义方法
//编   写：
//方法功能：设置是否自动下载音乐
- (IBAction)autoMusicDownload:(id)sender 
{
    BOOL lState;
    NSString *lMusicDownload;
    lState = self.autoDownload.isOn;//获得开关状态
    if (lState) 
    {
        lMusicDownload = [NSString stringWithFormat:@"YES"];
    }
    else
    {
        lMusicDownload = [NSString stringWithFormat:@"NO"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:lMusicDownload forKey:@"autoDownload"];
	[[NSUserDefaults standardUserDefaults]synchronize]; 
}

//方法类型：自定义方法
//编   写：
//方法功能：设置iCarousel呈现样式
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    printf("User Pressed Button %d\n", buttonIndex + 1);
    NSString *cfVlues;
    if (buttonIndex == 0) 
    {
        cfVlues = @"iCarouselTypeLinear";
        [bcfValues setTitle:@"直线" forState:UIControlStateNormal];
    }else if (buttonIndex == 1) 
    {
        cfVlues = @"iCarouselTypeRotary";
        [bcfValues setTitle:@"圆圈" forState:UIControlStateNormal];
    }else if (buttonIndex == 2) 
    {
        cfVlues = @"iCarouselTypeInvertedRotary";
        [bcfValues setTitle:@"圆圈(反向)" forState:UIControlStateNormal];
    }else if (buttonIndex == 3) 
    {
        cfVlues = @"iCarouselTypeCylinder";
        [bcfValues setTitle:@"圆柱" forState:UIControlStateNormal];
    }else if (buttonIndex == 4) 
    {
        cfVlues = @"iCarouselTypeInvertedCylinder";
        [bcfValues setTitle:@"圆柱(反向)" forState:UIControlStateNormal];
    }else if (buttonIndex == 5) 
    {
        cfVlues = @"iCarouselTypeWheel";
        [bcfValues setTitle:@"车轮" forState:UIControlStateNormal];
    }else if (buttonIndex == 6) 
    {
        cfVlues = @"iCarouselTypeInvertedWheel";
        [bcfValues setTitle:@"车轮(反向)" forState:UIControlStateNormal];
    }else if (buttonIndex == 7) 
    {
        cfVlues = @"iCarouselTypeCoverFlow";
        [bcfValues setTitle:@"CoverFlow1" forState:UIControlStateNormal];
    }else if (buttonIndex == 8) 
    {
        cfVlues = @"iCarouselTypeCoverFlow2";
        [bcfValues setTitle:@"CoverFlow2" forState:UIControlStateNormal];
    }else if (buttonIndex == 9) 
    {
        cfVlues = @"iCarouselTypeTimeMachine";
        [bcfValues setTitle:@"顺时针" forState:UIControlStateNormal];
    }else if (buttonIndex == 10) 
    {
        cfVlues = @"iCarouselTypeInvertedTimeMachine";
        [bcfValues setTitle:@"反时针" forState:UIControlStateNormal];
    }
    
	[[NSUserDefaults standardUserDefaults]setObject:cfVlues forKey:@"CoverFlow"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}

//方法类型：自定义方法
//编   写：
//方法功能：释放资源
- (void)viewDidUnload {
    [self setBcfValues:nil];
    [self setSMusicLyrics:nil];
    [self setSMusicImage:nil];
    [self setAutoDownload:nil];
    [super viewDidUnload];
}
@end
