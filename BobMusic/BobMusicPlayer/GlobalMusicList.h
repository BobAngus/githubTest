//
//  GlobalMusicList.h
//  BobMusicPlayer
//
//  Created by Bob Angus on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//存储播放列表，用于播放器的列表显示

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaItemCollection.h>

@interface GlobalMusicList : NSObject{
    NSString *GNSMusicListName;
    MPMediaItemCollection *GmediaItemCList;
    
    NSMutableArray		*soundFiles;
	NSString			*soundFilesPath;
	NSUInteger			selectedIndex;
}
+ (GlobalMusicList *)sharedSingleton;  
@property (nonatomic,retain) NSString *GNSMusicListName;
@property (nonatomic,retain) MPMediaItemCollection *GmediaItemCList; 

@property (nonatomic, retain) NSMutableArray *soundFiles;
@property (nonatomic, copy) NSString *soundFilesPath;
@property (nonatomic) NSUInteger selectedIndex;
@end
