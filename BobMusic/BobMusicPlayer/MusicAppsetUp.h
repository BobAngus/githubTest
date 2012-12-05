//
//  MusicAppsetUp.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JMStaticContentTableViewController.h"
@interface MusicAppsetUp : UIViewController<UIActionSheetDelegate>
- (IBAction)musicLyrics:(id)sender;
- (IBAction)musicImage:(id)sender;
- (IBAction)cfStyle:(id)sender;
- (IBAction)autoMusicDownload:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *sMusicLyrics;
@property (weak, nonatomic) IBOutlet UISwitch *sMusicImage;
@property (weak, nonatomic) IBOutlet UIButton *bcfValues;
@property (weak, nonatomic) IBOutlet UISwitch *autoDownload;

- (IBAction)testClick:(id)sender;
@end
